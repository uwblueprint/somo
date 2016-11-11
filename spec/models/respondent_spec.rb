require 'rails_helper'

RSpec.describe Respondent, type: :model do
  context "respondent is missing name" do
    subject { FactoryGirl.build(:respondent, name: "") }
    it { is_expected.not_to be_valid }
  end
  context "respondent is missing phone number" do
    subject { FactoryGirl.build(:respondent, phone_number: "") }
    it { is_expected.not_to be_valid }
  end
end
