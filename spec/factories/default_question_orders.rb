FactoryGirl.define do
  factory :default_question_order do
    question
    association :next_question, factory: :question
  end
end
