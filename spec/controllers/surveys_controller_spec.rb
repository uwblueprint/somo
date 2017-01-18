require 'rails_helper'

describe SurveysController, type: :controller do
  describe 'send survey validation' do
    before(:each) do
      allow_any_instance_of(Survey).to receive(:generate_models)
    end

    it 'returns respondents is empty' do
      FactoryGirl.create(:survey, :sendable, id: 1)
      post :send_survey, id: 1, respondent_phone_numbers: '[]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('respondents_is_empty')
    end

    it 'respondents is created' do
      allow_any_instance_of(Sms::Client).to receive(:send)
      FactoryGirl.create(:survey, :sendable, id: 1)
      expect {
        post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'
      }.to change { Respondent.count }.by(1)
    end

    it 'respondents is not created' do
      allow_any_instance_of(Sms::Client).to receive(:send)
      FactoryGirl.create(:survey, :sendable, id: 1)
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
      FactoryGirl.create(:survey, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')
      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('survey_is_not_sendable')
    end

    it 'returns respondent has survey in progress' do
      survey = FactoryGirl.create(:survey, :sendable)
      FactoryGirl.create(:respondent, :with_survey_execution_state, phone_number: '1-647-111-1111')
      post :send_survey, id: survey.id, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(400)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('respondents_has_survey_in_progress')
    end

    it 'send survey success single respondent' do
      allow_any_instance_of(Sms::Client).to receive(:send)
      FactoryGirl.create(:survey, :sendable, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')

      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(200)
    end

    it 'send survey success multiple respondents' do
      allow_any_instance_of(Sms::Client).to receive(:send)
      FactoryGirl.create(:survey, :sendable, id: 1)
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1111')
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1112')
      FactoryGirl.create(:respondent, phone_number: '1-647-111-1113')

      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111", "1-647-111-1112", "1-647-111-1113"]'
      expect(response.status).to eq(200)
    end

    it 'returns status code 422 for invalid survey parameters' do
      survey = FactoryGirl.create(:survey, :sendable, id: 1)
      allow_any_instance_of(Survey).to receive(:generate_models).and_raise(ActiveRecord::RecordInvalid.new(survey))
      post :send_survey, id: 1, respondent_phone_numbers: '["1-647-111-1111"]'

      expect(response.status).to eq(422)
      expect(response_json[:error_type]).to eq('record_invalid')
    end
  end

  describe 'GET #show' do
    let(:survey_parameters) do
      {
        name: 'My first survey',
        description: 'This is my first survey',
        questions: [
          {
            text: 'What is your name?',
            question_type: 'short_answer',
            default_next_question_id: 2,
            options: [],
          }
        ]
      }
    end
    let(:survey){ FactoryGirl.create(:survey, parameters: survey_parameters.to_json) }
    let(:request_params){ {id: survey.id} }

    it 'returns http success' do
      get :show, request_params.merge(format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'returns 404 for unknown id' do
      request_params[:id] = -1
      get :show, request_params.merge(format: :json)

      expect(response.status).to eq(404)
      expect(response_json[:error_type]).to eq('record_not_found')
    end

    it 'returns parameters from survey model' do
      get :show, request_params.merge(format: :json)
      expect(response_json[:id]).to eq(survey.id)
      expect(response_json[:name]).to eq('My first survey')
      expect(response_json[:questions].size).to eq(1)
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        name: 'My first survey',
        description: 'This is my first survey',
        questions: [
          {
            text: 'What is your name?',
            question_type: 'short_answer',
            default_next_question_id: 2,
            options: [],
          }, {
            text: 'Do you like cats?',
            question_type: 'multiple_choice',
            default_next_question_id: -1,
            options: [
              {
                key: 'a',
                text: 'Yes',
                next_question_id: -1,
              }, {
                key: 'b',
                text: 'No',
                next_question_id: -1,
              }, {
                key: 'c',
                text: 'Undecided',
                next_question_id: 3,
              }
            ]
          }, {
            text: 'What is your favourite colour?',
            question_type: 'short_answer',
            default_next_question_id: -1,
            options: [],
          }
        ],
      }
    end

    it 'returns http success' do
      post :create, params.merge(format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'returns parameters from survey model' do
      post :create, params.merge(format: :json)
      expect(response_json).to include('id')
      expect(response_json[:name]).to eq('My first survey')
      expect(response_json[:questions].size).to eq(3)
    end

    it 'creates a new survey' do
      expect{ post :create, params.merge(format: :json) }.to change{Survey.count}.by(1)
    end

    it 'copies params to survey.parameters' do
      post :create, params.merge(format: :json)
      expect(Survey.last.parameters.to_json).to eq(params.to_json)
    end

    it 'handles missing parameters' do
      missing_params = {
        name: 'My first survey',
        description: 'This is my first survey',
        questions: []
      }

      expect{ post :create, missing_params.merge(format: :json) }.to change{Survey.count}.by(1)
      expect(Survey.last.parameters.to_json).to eq(missing_params.to_json)
    end

    it 'filters out bad parameters' do
      params[:unexpected] = 'foobar'
      post :create, params.merge(format: :json)
      expect(Survey.last.parameters).not_to include('unexpected')
    end
  end

  describe 'PUT #update' do
    let!(:survey) { FactoryGirl.create(:survey, parameters: '{}') }
    let(:params) do
      {
        id: survey.id,
        name: 'My first survey',
        description: 'This is my updated survey',
        questions: [
          {
            text: 'What is your name?',
            question_type: 'short_answer',
            default_next_question_id: 2,
            options: [],
          }, {
            text: 'Do you like cats?',
            question_type: 'multiple_choice',
            default_next_question_id: -1,
            options: [
              {
                key: 'a',
                text: 'Yes',
                next_question_id: -1,
              }, {
                key: 'b',
                text: 'No',
                next_question_id: -1,
              }, {
                key: 'c',
                text: 'Undecided',
                next_question_id: -1,
              }
            ]
          }
        ],
      }
    end

    it 'returns 404 for unknown id' do
      params[:id] = -1
      put :update, params.merge(format: :json)

      expect(response.status).to eq(404)
      expect(response_json[:error_type]).to eq('record_not_found')
    end

    it 'returns 423 for sent survey' do
      allow_any_instance_of(Survey).to receive(:was_sent?).and_return(true)
      put :update, params.merge(format: :json)

      expect(response.status).to eq(423)
      expect(response_json[:error_type]).to eq('locked_resource_error')
    end

    it 'returns http success' do
      put :update, params.merge(format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'does not create a new survey' do
      expect{ put :update, params.merge(format: :json) }.not_to change{Survey.count}
    end

    it 'copies params to survey.parameters' do
      put :update, params.merge(format: :json)
      expect(Survey.last.parameters.to_json).to eq(params.except(:id).to_json)
    end

    it 'handles missing parameters' do
      missing_params = {
        id: survey.id,
        name: 'My first survey',
        description: 'This is my first survey',
        questions: []
      }

      post :update, missing_params.merge(format: :json)
      expect(Survey.last.parameters.to_json).to eq(missing_params.except(:id).to_json)
    end

    it 'filters out bad parameters' do
      params[:unexpected] = 'foobar'
      post :update, params.merge(format: :json)
      expect(Survey.last.parameters).not_to include('unexpected')
    end

    it 'returns parameters from survey model' do
      post :update, params.merge(format: :json)
      expect(response_json[:id]).to eq(survey.id)
      expect(response_json[:name]).to eq('My first survey')
      expect(response_json[:questions].size).to eq(2)
    end
  end

  describe 'GET #index' do
    let(:first_survey_parameters) {
      {
        name: 'My first survey',
        description: 'This is my first survey',
        questions: [
          {
            text: 'What is your name?',
            question_type: 'short_answer',
            default_next_question_id: 2,
            options: [],
          }
        ]
      }
    }

    let(:second_survey_parameters) {
      {
        name: 'Second survey',
        description: 'This is my second survey',
        questions: []
      }
    }

    let(:first_expected_survey) {
      {
        id: 1,
        name: 'My first survey',
        description: 'This is my first survey',
        number_of_questions: 1
      }
    }

    let(:second_expected_survey) {
      {
        id: 2,
        name: 'Second survey',
        description: 'This is my second survey',
        number_of_questions: 0
      }
    }

    context 'no surveys' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns empty response' do
        get :index
        expect(response.body).to eq({ surveys: [] }.to_json)
      end
    end

    context 'single survey' do
      before(:each)  do
        FactoryGirl.create(:survey, id: 1, parameters: first_survey_parameters.to_json)
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns surveys response' do
        expect(response.body).to eq({ surveys: [first_expected_survey] }.to_json)
      end
    end

    context 'multiple surveys' do

      before(:each)  do
        FactoryGirl.create(:survey, id: 1, parameters: first_survey_parameters.to_json)
        FactoryGirl.create(:survey, id: 2, parameters: second_survey_parameters.to_json)
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns two surveys response' do
        expect(response.body).to eq(
          { surveys: [second_expected_survey, first_expected_survey] }.to_json)
      end
    end

    context 'pagination for surveys' do
      before(:each) do
        for i in 1..11
          FactoryGirl.create(:survey, id: i, parameters:first_survey_parameters.to_json)
        end
      end

      it 'returns http success for first page' do
        get :index, { page: 1 }
        expect(response).to have_http_status(:success)
      end

      it 'returns first page for surveys response' do
        get :index, { page: 1 }
        surveys = JSON.parse(response.body)['surveys']
        expect(surveys.length).to eq(10)
        expect(surveys.first['id']).to eq(11)
        expect(surveys.last['id']).to eq(2)
      end

      it 'returns http success for second page' do
        get :index, { page: 2 }
        expect(response).to have_http_status(:success)
      end

      it 'returns second page for surveys response' do
        get :index, { page: 2 }
        surveys = JSON.parse(response.body)['surveys']
        expect(surveys.length).to eq(1)
        expect(surveys.first['id']).to eq(1)
      end
    end
  end
end
