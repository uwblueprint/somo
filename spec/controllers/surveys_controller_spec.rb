require 'rails_helper'

describe SurveysController, type: :controller do
  context 'send survey validation' do

    it 'returns respondents is empty' do
      FactoryGirl.create(:survey, id: 1)
      post :send_survey, id: 1, respondent_phone_numbers: '[]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('respondents_is_empty')
    end

    it 'respondents is created' do
      FactoryGirl.create(:survey, id: 1)
      expect {
        post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'
      }.to change { Respondent.count }.by(1)
    end

    it 'respondents is not created' do
      FactoryGirl.create(:survey, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')
      expect {
        post :send_survey, id: 1, respondent_phone_numbers: '["16471111111"]'
      }.to_not change { Respondent.count }
    end

    it 'returns survey not found' do
      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(404)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('survey_not_found')
    end

    it 'returns survey is not sendable when first question doesn\'t exist' do
      FactoryGirl.create(:survey, id: 1, first_question: nil)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')
      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('survey_is_not_sendable')
    end

    it 'returns respondent has survey in progress' do
      FactoryGirl.create(:respondent, :with_survey_execution_state, phone_number: '1-647-111-1111')
      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('respondents_has_survey_in_progress')
    end

    it 'send survey success single respondent' do
      FactoryGirl.create(:survey, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')

      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(200)
    end

    it 'send survey success multiple respondents' do
      FactoryGirl.create(:survey, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1112')
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1113')

      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111", "1-647-111-1112", "1-647-111-1113"]'
      expect(response.status).to eq(200)
    end
  end
end
