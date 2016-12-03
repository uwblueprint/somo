FactoryGirl.define do
  factory :conditional_question_order do
    question
    response_choice
    association :next_question, factory: :question
  end
end
