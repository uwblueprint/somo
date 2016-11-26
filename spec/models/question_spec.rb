require "rails_helper"

describe Question do
  context "question is missing text" do
    subject { FactoryGirl.build(:question, text: "") }
    it { is_expected.not_to be_valid }
  end

  context "question is missing question_type" do
    subject {FactoryGirl.build(:question, question_type: "")}
    it { is_expected.not_to be_valid }
  end

  context "question has invalid question_type" do
    subject {FactoryGirl.build(:question, question_type: "laksdjlsajdl")}
    it { is_expected.not_to be_valid }
  end

  context "with response choices" do
    subject { FactoryGirl.create(:question, :with_response_choice) }

    it "has response choices" do
      expect(subject.response_choices).to_not be_empty
      expect(subject.response_choices.first).to be_a(ResponseChoice)
    end
  end

  context "with question order" do
    subject { FactoryGirl.create(:question, :with_question_order) }

    it "has a next question" do
      expect(subject.question_order).to be_a(QuestionOrder);
      expect(subject.question_order.question).to eq(subject);
      expect(subject.question_order.next_question).to be_a(Question);
    end
  end

  context "with conditional question order" do
    subject { FactoryGirl.create(:question, :with_conditional_question_order) }

    it "next question associated with response choice" do
      expect(subject.question_order).to be_a(ConditionalQuestionOrder);
      expect(subject.question_order.question).to eq(subject);
      expect(subject.question_order.next_question).to be_a(Question);
      expect(subject.response_choices).to include(subject.question_order.response_choice)
    end
  end
end
