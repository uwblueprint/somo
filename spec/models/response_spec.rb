require 'rails_helper'

RSpec.describe Response, type: :model do
  context 'is missing answer' do
    subject { FactoryGirl.build(:response, answer: '') }
    it { is_expected.not_to be_valid }
  end

  context 'is valid' do
    subject { FactoryGirl.build(:response)}
    it { is_expected.to be_valid }
  end

  context 'is valid with survey_response' do
    subject { FactoryGirl.build(:response, :with_survey_response)}
    it {
      is_expected.to be_valid
      expect(subject.survey_response).not_to be_nil
    }
  end
end
