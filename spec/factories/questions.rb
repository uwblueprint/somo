FactoryGirl.define do
  factory :question do
    text 'hello world?'
    question_type 'short_answer'
    number 1
    survey
  end

  trait :with_default_question_order do
    after(:create) do |question|
      create(:default_question_order, question: question)
    end
  end

  trait :with_conditional_question_order do
    before(:create) do |question|
      question.question_type = 'multiple_choice'
    end
    after(:create) do |question|
      rc = create(:response_choice, question: question)
      create(:conditional_question_order, question: question, response_choice: rc)
    end
  end

  trait :with_response_choice do
    after(:create) do |question|
      create(:response_choice, question: question)
    end
  end
  
  trait :with_multiple_response_choices do
    after(:create) do |question|
      create(:response_choice, question: question)
      create(:response_choice, question: question, key: 'b', text: 'second choice')
    end
  end
end
