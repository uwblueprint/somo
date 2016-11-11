FactoryGirl.define do
  factory :question_order do
    question
    survey
    association :next_question, factory: :question
  end
end
