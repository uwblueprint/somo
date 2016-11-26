require "rails_helper"

describe ResponseChoice do
  context "response_choice is missing key" do
    subject { FactoryGirl.build(:response_choice, key: "") }
    it { is_expected.not_to be_valid }
  end

  context "response_choice has invalid key" do
    subject { FactoryGirl.build(:response_choice, key: "a") }
    it { is_expected.not_to be_valid }
  end
end
