require 'rails_helper'

RSpec.describe SurveyResponse, type: :model do
  subject { FactoryGirl.create(:survey_response) }

  it "has a survey" do
    expect(subject.survey).not_to be_nil
  end

  it "has a respondent" do
    expect(subject.respondent).not_to be_nil
  end
end
