class SurveysController < ApplicationController

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
end
