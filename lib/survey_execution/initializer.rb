module SurveyExecution
  class Initializer
    def initialize(client, survey, respondents)
      @client = client
      @survey = survey
      @respondents = respondents
    end

    def execute
      @respondents.each do |respondent|
        SurveyExecutionState.create(
          respondent: respondent, survey: @survey, question: @survey.first_question)

        @client.send(respondent.phone_number, @survey.welcome_message)
        @client.send(respondent.phone_number, @survey.first_question.formatted_question_and_responses)
      end
    end
  end
end
