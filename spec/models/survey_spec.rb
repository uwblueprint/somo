require "rails_helper"

describe Survey do
  context "survey is missing description" do
    subject { FactoryGirl.build(:survey, description: "") }
    it { is_expected.not_to be_valid }
  end

  context "survey is missing name" do
    subject { FactoryGirl.build(:survey, name: "") }
    it { is_expected.not_to be_valid }
  end
end
