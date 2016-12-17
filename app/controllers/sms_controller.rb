class SmsController < BaseController
  # Twilio will call various endpoints in this controller

  INITIALIZED = SurveyExecutionState.statuses[:initialized]
  IN_PROGRESS = SurveyExecutionState.statuses[:in_progress]
  FINISHED = SurveyExecutionState.statuses[:finished]

  # Twilio calls this endpoint when a user sends a message to us
  def received_user_response
    answer = params[:Body]
    phone_number = params[:From]

    respondent = Respondent.find_by_phone_number(phone_number.phony_normalized) || raise(RespondentNotFoundError)
    state = respondent.survey_execution_states.find_by(status: [INITIALIZED, IN_PROGRESS]) ||
      raise(SurveyExecutionStateNotFoundError)

    survey = state.survey
    question = state.question

    if question.response_choices.exists?
      # Lowercase for a case-insensitive comparison against the response choices
      # and persist it this way for consistency
      answer = answer.downcase
    end

    survey_response = SurveyResponse.find_or_create_by(survey: survey, respondent: respondent)
    response = Response.new(
      survey_response: survey_response, respondent: respondent, question: question, answer: answer)

    if question.is_response_valid?(response)
      response.save!
      next_question = question.next_question(response)
      if next_question.nil?
        message = survey.finished_message
        state.status = FINISHED
      else
        message = next_question.formatted_question_and_responses
        state.question = next_question
        state.status = IN_PROGRESS
      end
    else
      message = 'Invalid response, please try again.'
      state.status = IN_PROGRESS
    end
    state.save

    Sms::Client.instance.send(respondent.phone_number, message)

    head :ok
  end
end
