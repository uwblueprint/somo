require 'rails_helper'

describe Survey do

  context 'survey with first_question' do
    subject { FactoryGirl.create(:survey, :with_first_question) }

    it 'has a first question that is a question' do
      expect(subject.first_question).to be_a(Question)
    end

    it 'is sendable' do
      expect(subject.is_sendable?).to be true
    end
  end

  describe '#metadata' do

    context 'survey with no parameters' do
      it 'returns metadata successfully' do
        subject{ FactoryGirl.create(:survey) }
        expect(subject.metadata).to eq({
          id: -1,
          name: '(No title)',
          description: '(No description)',
          number_of_questions: 0
        })
      end
    end

    context 'survey with parameters' do
      let(:params) do
        {
          name: 'My first survey',
          description: 'This is my first survey',
          questions: [
            {
              text: 'What is your name?',
              question_type: 'short_answer',
              default_next_question_id: 2,
              options: []
            },
            {
              text: 'Is fire hot?',
              question_type: 'short_answer',
              default_next_question_id: -1,
              options: []
            }
          ]
        }
      end

      it 'returns successful metadata' do
        survey = FactoryGirl.create(:survey, id: 1, parameters: params)
        expect(survey.metadata).to eq({
          id: 1,
          name: 'My first survey',
          description: 'This is my first survey',
          number_of_questions: 2
        })
      end
    end
  end

  describe '#generate_models' do
    subject{ FactoryGirl.create(:survey, name: '', description: '', parameters: params)}

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
            text: 'Is fire hot?',
            question_type: 'true_false',
            default_next_question_id: 3,
            options: [
              {
                key: 't',
                text: 'True',
                next_question_id: -1,
              }, {
                key: 'f',
                text: 'False',
                next_question_id: -1,
              }
            ],
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
                next_question_id: 4,
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

    it 'creates four new questions' do
      expect{ subject.generate_models}.to change{Question.count}.by(4)
    end

    it 'creates five new response choices' do
      expect{ subject.generate_models}.to change{ResponseChoice.count}.by(5)
    end

    it 'creates three new question orders' do
      expect{ subject.generate_models}.to change{QuestionOrder.count}.by(3)
    end

    it 'has the right first question' do
      subject.generate_models

      expect(Survey.last.first_question.number).to eq(1)
      expect(Survey.last.first_question.text).to eq('What is your name?')
    end

    it 'creates default question orders' do
      subject.generate_models

      survey = Survey.last
      expect(survey.first_question.question_orders.size).to eq(1)
      expect(survey.first_question.question_orders.first).to be_a(DefaultQuestionOrder)
      expect(survey.first_question.question_orders.first.next_question.number).to be(2)
    end

    it 'creates conditional question orders' do
      subject.generate_models

      question = Survey.last.questions.find_by_number(3)
      expect(question.question_orders.size).to eq(1)
      expect(question.question_orders.first).to be_a(ConditionalQuestionOrder)
      expect(question.question_orders.first.response_choice).to_not be_nil
      expect(question.question_orders.first.next_question).to eq(Question.last)
    end

    it 'parses last question with default question order' do
      subject.generate_models

      question = Question.last
      expect(question.question_orders).to be_empty
    end

    context 'with missing params' do
      it 'throws RecordInvalid' do
        params[:questions].first[:text] = nil
        expect{ subject.generate_models }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid params' do
      it 'throws RecordInvalid' do
        params[:questions].first[:question_type] = 'invalid_question_type'
        expect{ subject.generate_models }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
