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
  
  context 'formats as csv' do
    let(:respondent) { FactoryGirl.create(:respondent)}
    let(:survey) { FactoryGirl.create(:survey)}
    let(:survey_response) {FactoryGirl.create(:survey_response, survey: survey, respondent: respondent)}
    let(:question1) {FactoryGirl.create(:question, survey: survey)}
    let(:response) {FactoryGirl.create(:response, survey_response: survey_response, respondent: respondent, question: question1)}
    
    it 'compiles' do
      puts survey.survey_responses.size
      puts survey.survey_responses.count
      survey.survey_responses.each do |sur_resp|
        puts "respondent: " + sur_resp.respondent
        puts sur_resp.responses.collect{|r| r.text}
      end

      puts survey.questions.size
      puts survey.questions.count
      survey.questions.each do |q|
        puts "question: #{q.text}"
      end
      
      survey.to_csv
    end

  end
end
