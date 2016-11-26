FactoryGirl.define do
  factory :survey_execution_state do
    respondent
    question
    survey
  end
end
