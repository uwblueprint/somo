FactoryGirl.define do
  factory :survey do
    name 'hello world'
    description 'a test survey'
  end

  trait :with_first_question do
    after(:create) do |survey|
      survey.update!(first_question: create(:question, {survey: survey}))
    end
  end

  trait :sendable do
    with_first_question
  end
end
