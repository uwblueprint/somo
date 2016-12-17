require 'rails_helper'

describe Question do
  context 'question is missing text' do
    subject { FactoryGirl.build(:question, text: '') }
    it { is_expected.not_to be_valid }
  end

  context 'question is missing question_type' do
    subject {FactoryGirl.build(:question, question_type: '')}
    it { is_expected.not_to be_valid }
  end

  context 'question has invalid question_type' do
    subject {FactoryGirl.build(:question, question_type: 'laksdjlsajdl')}
    it { is_expected.not_to be_valid }
  end

  context 'question is missing number' do
    subject { FactoryGirl.build(:question, number: nil) }
    it { is_expected.not_to be_valid }
  end

  context 'question has no next question' do
    subject { FactoryGirl.build(:question) }
    it { expect(subject.next_question('test')).to be_nil }
  end

  context 'with response choices' do
    subject { FactoryGirl.create(:question, :with_response_choice) }

    it 'has response choices' do
      expect(subject.response_choices).to_not be_empty
      expect(subject.response_choices.first).to be_a(ResponseChoice)
    end
  end

  context 'with default question order' do
    subject { FactoryGirl.create(:question, :with_default_question_order) }

    context 'has a next question' do
      it 'model is valid' do
        expect(subject.question_orders.first).to be_a(QuestionOrder)
        expect(subject.question_orders.first.question).to eq(subject)
        expect(subject.question_orders.first.next_question).to be_a(Question)
      end

      it 'next_question is valid' do
        response = FactoryGirl.create(:response)
        expect(subject.is_response_valid?(response)).to be true
        expect(subject.next_question(response)).to eq(subject.question_orders.first.next_question)
      end

    end
  end

  context 'with conditional question order' do
    subject { FactoryGirl.create(:question, :with_conditional_question_order) }

    context 'next question associated with response choice' do
      it 'model is valid' do
        expect(subject.question_orders.first).to be_a(ConditionalQuestionOrder)
        expect(subject.question_orders.first.question).to eq(subject)
        expect(subject.question_orders.first.next_question).to be_a(Question)
        expect(subject.response_choices).to include(subject.question_orders.first.response_choice)
      end

      it 'next_question method is successful' do
        response = FactoryGirl.create(:response)
        expect(subject.is_response_valid?(response)).to be true
        expect(subject.next_question(response)).to eq(subject.question_orders.first.next_question)
      end

      it 'response is not valid' do
        response = FactoryGirl.create(:response, answer: 'c')
        expect(subject.is_response_valid?(response)).to be false
        expect(subject.next_question(response)).to be_nil
      end
    end

    context 'next question associated with multiple response choices' do
      let(:next_question) { FactoryGirl.create(:question) }
      let(:response_choice) { FactoryGirl.create(:response_choice, question: subject, key: 'b') }

      before(:each) do
        FactoryGirl.create(:conditional_question_order, question: subject,
                           next_question: next_question, response_choice: response_choice)
      end

      it 'first response choice is valid' do
        response = FactoryGirl.create(:response, answer: 'a')
        expect(subject.is_response_valid?(response)).to be true
        expect(subject.next_question(response)).to eq(subject.question_orders.first.next_question)
      end

      it 'second response choice is valid' do
        response = FactoryGirl.create(:response, answer: 'b')
        expect(subject.is_response_valid?(response)).to be true
        expect(subject.next_question(response)).to eq(next_question)
      end

      it 'response is not valid' do
        response = FactoryGirl.create(:response, answer: 'c')
        expect(subject.is_response_valid?(response)).to be false
        expect(subject.next_question(response)).to be_nil
      end
    end
  end
end
