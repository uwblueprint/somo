require 'rails_helper'

describe Survey do
  context 'survey is missing description' do
    subject { FactoryGirl.build(:survey, description: '') }
    it { is_expected.not_to be_valid }
  end

  context 'survey is missing name' do
    subject { FactoryGirl.build(:survey, name: '') }
    it { is_expected.not_to be_valid }
  end

  context 'survey with first_question' do
    subject { FactoryGirl.build(:survey, :with_first_question) }

    it 'has a first question that is a question' do
      expect(subject.first_question).to be_a(Question)
    end

    it 'is sendable' do
      expect(subject.is_sendable?).to be true
    end
  end
end
