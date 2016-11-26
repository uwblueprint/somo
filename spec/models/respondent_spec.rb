require 'rails_helper'

RSpec.describe Respondent, type: :model do
  context "is missing name" do
    subject { FactoryGirl.build(:respondent, name: "") }
    it { is_expected.to be_valid }
  end

  context "is missing phone number" do
    subject { FactoryGirl.build(:respondent, phone_number: "") }
    it { is_expected.not_to be_valid }
  end

  context "phone number is missing country number" do
    subject { FactoryGirl.build(:respondent, phone_number: "8181231234") }
    it { is_expected.not_to be_valid }
  end

  context "is valid" do
    subject { FactoryGirl.build(:respondent) }
    it { is_expected.to be_valid }
  end
end
