require 'rails_helper'

describe SmsController, type: :controller do
  describe '#received_user_response' do
    context 'missing resources' do
      let(:question) { FactoryGirl.create(:question, :with_conditional_question_order, text: 'hello?') }
      let(:survey) { FactoryGirl.create(:survey, first_question: question) }
      let(:respondent) { FactoryGirl.create(:respondent) }
      let(:client) { Sms::Client.instance }

      it 'unable to find survey execution state' do
        FactoryGirl.create(:survey_execution_state, respondent: respondent, survey: survey,
                           question: question, status: SurveyExecutionState.statuses[:finished])
        allow(client).to receive(:send)
        post :received_user_response, From: respondent.phone_number, Body: 'A'
        expect(response.status).to eq(404)
      end

      it 'unable to find respondent' do
        FactoryGirl.create(:survey_execution_state, respondent: respondent, survey: survey, question: question)
        allow(client).to receive(:send)
        post :received_user_response, From: '19058877777', Body: 'A'
        expect(response.status).to eq(404)
      end
    end

    context 'response to a conditional question of survey' do
      let(:question) { FactoryGirl.create(:question, :with_conditional_question_order, text: 'hello?') }
      let(:survey) { FactoryGirl.create(:survey, first_question: question) }
      let(:respondent) { FactoryGirl.create(:respondent) }
      let(:client) { Sms::Client.instance }
      let(:next_question) { question.response_choices.first.question_order.next_question }

      context 'response is valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          post :received_user_response, From: respondent.phone_number, Body: 'A'
        end

        it 'updates state' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.status).to eq('in_progress')
          expect(state.question).to eq(next_question)
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
            respondent.phone_number, next_question.formatted_question_and_responses)
        end

        it 'creates a survey response and response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'a')).to exist
        end
      end

      context 'response is not valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          post :received_user_response, From: respondent.phone_number, Body: 'B'
        end

        it 'updates state status but not next question' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.status).to eq('in_progress')
          expect(state.question).to eq(question)
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
          respondent.phone_number, 'Invalid response, please try again.')
        end

        it 'creates a survey response, but not a response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'b')).not_to exist
        end
      end
    end

    context 'response to a default question of survey' do
      let(:question) { FactoryGirl.create(:question, :with_default_question_order, text: 'hello?') }
      let(:survey) { FactoryGirl.create(:survey, first_question: question) }
      let(:respondent) { FactoryGirl.create(:respondent) }
      let(:client) { Sms::Client.instance }
      let(:next_question) { question.question_orders.first.next_question }

      context 'response is valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          post :received_user_response, From: respondent.phone_number, Body: 'A'
        end

        it 'updates state' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.status).to eq('in_progress')
          expect(state.question).to eq(next_question)
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
            respondent.phone_number, next_question.formatted_question_and_responses)
        end

        it 'creates a survey response and response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'A')).to exist
        end
      end
    end

    context 'response to the last question of a survey that\s conditional' do
      let(:question) { FactoryGirl.create(:question, :with_conditional_question_order) }
      let(:survey) { FactoryGirl.create(:survey, first_question: question) }
      let(:respondent) { FactoryGirl.create(:respondent) }
      let(:client) { Sms::Client.instance }
      let(:question_order) { question.response_choices.first.question_order }

      context 'response is valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          question_order.delete
          post :received_user_response, From: respondent.phone_number, Body: 'A'
        end

        it 'updates state' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.question).to eq(question)
          expect(state.status).to eq('finished')
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
            respondent.phone_number, survey.finished_message)
        end

        it 'creates a survey response and response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'a')).to exist
        end
      end

      context 'response is not valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          post :received_user_response, From: respondent.phone_number, Body: 'B'
        end

        it 'updates state status but not next question' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.status).to eq('in_progress')
          expect(state.question).to eq(question)
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
          respondent.phone_number, 'Invalid response, please try again.')
        end

        it 'creates a survey response, but not a response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'b')).not_to exist
        end
      end
    end

    context 'response to the last question which is a default question' do
      let(:question) { FactoryGirl.create(:question, :with_default_question_order, text: 'hello?') }
      let(:survey) { FactoryGirl.create(:survey, first_question: question) }
      let(:respondent) { FactoryGirl.create(:respondent) }
      let(:client) { Sms::Client.instance }
      let(:question_order) { question.question_orders.first }

      context 'response is valid' do
        before(:each) do
          FactoryGirl.create(
            :survey_execution_state, respondent: respondent, survey: survey, question: question)
          allow(client).to receive(:send)
          question_order.delete
          post :received_user_response, From: respondent.phone_number, Body: 'A'
        end

        it 'updates state' do
          state = SurveyExecutionState.find_by(respondent: respondent)
          expect(state.status).to eq('finished')
          expect(state.question).to eq(question)
        end

        it 'sends sms' do
          expect(client).to have_received(:send).with(
            respondent.phone_number, survey.finished_message)
        end

        it 'creates a survey response and response' do
          expect(SurveyResponse.where(respondent: respondent, survey: survey)).to exist
          expect(Response.where(respondent: respondent, question: question, answer: 'A')).to exist
        end
      end
    end
  end
end
