FactoryGirl.define do
  factory :survey do
    name 'hello world'
    description 'a test survey'
    association :first_question, factory: :question
  end

  trait :with_first_question do
    after(:create) do |survey|
      create(:question, survey: survey)
    end
  end
  
  trait :with_responses do
    after(:create) do |survey|
      create(:question, survey: survey)
      create(:response, survey: survey)
    end
  end
end
