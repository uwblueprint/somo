FactoryGirl.define do
  factory :response do
    survey_response
    question
    respondent
    answer "My answer"
  end
end
