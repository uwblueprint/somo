require 'rails_helper'

describe ConditionalQuestionOrder do
  subject { FactoryGirl.create(:conditional_question_order) }

  it 'has a response choice' do
    expect(subject.response_choice).to be_a(ResponseChoice)
  end

  it 'has a next question' do
    expect(subject.next_question).to be_a(Question)
  end

  it 'has a question' do
    expect(subject.question).to be_a(Question)
  end

  context 'with no next question' do
    subject { FactoryGirl.create(:conditional_question_order, next_question: nil) }

    it { is_expected.to be_valid }
  end
end
