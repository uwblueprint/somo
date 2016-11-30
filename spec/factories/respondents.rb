FactoryGirl.define do
  factory :respondent do
    name 'Jon Doe'
    phone_number '+1-818-111-1111'
  end

  trait :with_survey_execution_state do
    after(:create) do |respondent|
      create(:survey_execution_state, :respondent => respondent)
    end
  end
end
