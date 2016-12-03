class SurveysController < BaseController

  def send_survey
    phone_numbers = JSON.parse(params[:respondent_phone_numbers]).uniq
    if phone_numbers.empty?
      return render json: {error: :respondents_is_empty}, status: :bad_request
    end

    begin
      survey_id = params[:id]
      @survey = Survey.find(survey_id)
    rescue ActiveRecord::RecordNotFound
      return render json: {error: :survey_not_found}, status: :not_found
    end

    if !@survey.is_sendable?
      return render json: {error: :survey_is_not_sendable}, status: :bad_request
    end

    respondents = phone_numbers.map do |phone_number|
      Respondent.find_or_create_by(phone_number: phone_number.phony_normalized)
    end

    invalid_respondents = respondents.select { |respondent| !respondent.accepting_surveys? }
    if invalid_respondents.any?
      return render json: {error: :respondents_has_survey_in_progress}, status: :bad_request
    end

    initializer = SurveyExecution::Initializer.new(@survey, respondents)
    initializer.execute

    head :ok
  end

  def create
    @survey = Survey.create!(survey_params)

    questions = params[:questions].map do |question_params|
      question = Question.create!(
        survey: @survey,
        text: question_params[:text],
        question_type: question_params[:question_type].downcase,
        number: question_params[:id],
      )

      question_params[:options].each do |response_params|
        ResponseChoice.create!(
          question: question,
          key: response_params[:key].downcase,
          text: response_params[:text],
        )
      end

      [
        question_params[:id],
        question
      ]
    end
    questions = questions.to_h

    @survey.update!(first_question: questions['1'])

    params[:questions].each do |question_params|
      if (question_params[:default_next_question_id].to_i == -1)
        question_params[:options].each do |response_params|
          if (questions.keys.include? response_params[:next_question_id])
            ConditionalQuestionOrder.create!(
              question: questions[question_params[:id]],
              response_choice: questions[question_params[:id]].response_choices.find_by_key(response_params[:key]),
              next_question: questions[response_params[:next_question_id]]
            )
          end
        end
      else
        if (questions.keys.include? question_params[:default_next_question_id])
          DefaultQuestionOrder.create!(
            question: questions[question_params[:id]],
            next_question: questions[question_params[:default_next_question_id]]
          )
        end
      end
    end

    # TODO(dinah): remove this empty json when survey jbuilder is complete
    render json: {}
  end

private

  def survey_params
    params.permit(
      :name,
      :description,
    )
  end
end
