module SurveyExecution
  class Initializer
    def initialize(survey, respondents)
      @client = Sms::Client.instance
      @survey = survey
      @respondents = respondents
    end

    def execute
      # TODO (Chris): create survey execution states and send texts
    end
  end
end
