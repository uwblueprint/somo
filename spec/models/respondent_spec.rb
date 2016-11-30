require 'rails_helper'

RSpec.describe Respondent, type: :model do
  context 'is missing name' do
    subject { FactoryGirl.build(:respondent, name: '') }
    it { is_expected.to be_valid }
  end

  context 'is missing phone number' do
    subject { FactoryGirl.build(:respondent, phone_number: '') }
    it { is_expected.not_to be_valid }
  end

  context 'phone number is missing country number' do
    subject { FactoryGirl.build(:respondent, phone_number: '8181231234') }
    it { is_expected.not_to be_valid }
  end

  context 'is valid' do
    subject { FactoryGirl.create(:respondent) }
    it { is_expected.to be_valid }
    it { expect(subject.accepting_surveys?).to be true }
  end

  context 'accepting surveys' do
    subject { FactoryGirl.create(:respondent, :with_survey_execution_state) }
    it { expect(subject.accepting_surveys?).to be false }
  end

end
