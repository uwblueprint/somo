describe SurveyExecution::Initializer, type: :controller do

  let(:survey) { FactoryGirl.create(:survey, id: 1, first_question: question) }
  let(:question) { FactoryGirl.create(:question, id: 1)}
  let(:client) { double('client') }

  context 'single respondent' do
    let(:respondent) { FactoryGirl.create(:respondent, id: 1)}
    subject{ SurveyExecution::Initializer.new(client, survey, [respondent]) }

    it 'create survey execution state' do
      allow(client).to receive(:send)
      subject.execute
      expect(SurveyExecutionState.where(
        respondent: respondent, survey: survey, question: question)).to exist
    end

    it 'send survey message and first question' do
      allow(client).to receive(:send)
      subject.execute
      expect(client).to have_received(:send).twice
      expect(client).to have_received(:send).with(
        respondent.phone_number, survey.welcome_message)
      expect(client).to have_received(:send).with(
        respondent.phone_number, question.formatted_question_and_responses)
    end
  end

  context 'multiple respondents' do
    let(:first_respondent) { FactoryGirl.create(:respondent, id: 1)}
    let(:second_respondent) { FactoryGirl.create(:respondent, id: 2, phone_number: '+1-905-999-9999')}
    subject{ SurveyExecution::Initializer.new(client, survey, [first_respondent, second_respondent]) }

    it 'create survey execution state' do
      allow(client).to receive(:send)
      subject.execute
      expect(SurveyExecutionState.where(
        respondent: first_respondent, survey: survey, question: question)).to exist
      expect(SurveyExecutionState.where(
        respondent: second_respondent, survey: survey, question: question)).to exist
    end

    it 'send survey message and first question' do
      allow(client).to receive(:send)
      subject.execute
      expect(client).to have_received(:send).exactly(4).times
      expect(client).to have_received(:send).with(
        first_respondent.phone_number, survey.welcome_message)
      expect(client).to have_received(:send).with(
        first_respondent.phone_number, question.formatted_question_and_responses)
      expect(client).to have_received(:send).with(
        second_respondent.phone_number, survey.welcome_message)
      expect(client).to have_received(:send).with(
        second_respondent.phone_number, question.formatted_question_and_responses)
    end
  end
end
