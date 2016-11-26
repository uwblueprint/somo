require 'rails_helper'

RSpec.describe SurveyExecutionState, type: :model do
  context "is valid" do
    subject { FactoryGirl.build(:survey_execution_state) }
    it { is_expected.to be_valid }
  end

  context "is missing question" do
    subject { FactoryGirl.build(:survey_execution_state, question: nil) }
    it { is_expected.not_to be_valid }
  end

  context "is missing respondent" do
    subject { FactoryGirl.build(:survey_execution_state, respondent: nil) }
    it { is_expected.not_to be_valid }
  end

  context "is missing survey" do
    subject { FactoryGirl.build(:survey_execution_state, survey: nil) }
    it { is_expected.not_to be_valid }
  end

end
