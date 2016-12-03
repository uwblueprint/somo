require 'rails_helper'

describe SurveysController, type: :controller do
  describe 'send survey validation' do
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

  describe 'POST #create' do
    let(:params) do
      {
        name: 'My first survey',
        description: 'This is my first survey',
        questions: [
          {
            id: 1,
            text: 'What is your name?',
            question_type: 'short_answer',
            default_next_question_id: 2,
            options: [],
          }, {
            id: 2,
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
            id: 3,
            text: 'What is your favourite colour?',
            question_type: 'short_answer',
            default_next_question_id: -1,
            options: [],
          }
        ],
      }
    end

    it 'returns http success' do
      get :create, params
      expect(response).to have_http_status(:success)
    end

    it 'creates a new survey' do
      expect{ get :create, params}.to change{Survey.count}.by(1)
    end

    it 'creates three new questions' do
      expect{ get :create, params}.to change{Question.count}.by(3)
    end

    it 'creates three new response choices' do
      expect{ get :create, params}.to change{ResponseChoice.count}.by(3)
    end

    it 'creates two new question orders' do
      expect{ get :create, params}.to change{QuestionOrder.count}.by(2)
    end

    it 'has the right first question' do
      get :create, params

      expect(Survey.last.first_question.number).to eq(1)
      expect(Survey.last.first_question.text).to eq('What is your name?')
    end

    it 'creates default question orders' do
      get :create, params

      survey = Survey.last
      expect(survey.first_question.question_orders.size).to eq(1)
      expect(survey.first_question.question_orders.first).to be_a(DefaultQuestionOrder)
      expect(survey.first_question.question_orders.first.next_question.number).to be(2)
    end

    it 'creates conditional question orders' do
      get :create, params

      question = Survey.last.questions.find_by_number(2)
      expect(question.question_orders.size).to eq(1)
      expect(question.question_orders.first).to be_a(ConditionalQuestionOrder)
      expect(question.question_orders.first.response_choice).to_not be_nil
      expect(question.question_orders.first.next_question).to eq(Question.last)
    end

    it 'parses last question with default question order' do
      get :create, params

      question = Question.last
      expect(question.question_orders).to be_empty
    end

    context 'with missing params' do
      it 'returns status code 422' do
        params[:name] = nil
        get :create, params

        expect(response.status).to eq(422)
        expect(response_json[:error_type]).to eq('record_invalid')
      end
    end

    context 'with invalid params' do
      it 'returns status code 422' do
        params[:questions].first[:question_type] = 'invalid_question_type'
        get :create, params

        expect(response.status).to eq(422)
        expect(response_json[:error_type]).to eq('record_invalid')
      end
    end
  end
end
