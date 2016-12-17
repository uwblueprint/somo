FactoryGirl.define do
  factory :response do
    question
    respondent
    answer 'a'
  end

  trait :with_survey_response do
    after(:build) do |response|
      response.survey_response = create(:survey_response, respondent: response.respondent)
    end
  end
end
