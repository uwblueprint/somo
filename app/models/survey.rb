# == Schema Information
#
# Table name: surveys
#
#  id                                   :integer          not null, primary key
#  name                                 :string
#  description                          :text
#  parameters                           :json
#  first_question_id                    :integer
#  survey_id                            :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Survey < ActiveRecord::Base
  has_many :questions
  has_many :survey_execution_states
  has_many :survey_responses

  belongs_to :first_question, foreign_key: :first_question_id, class_name: 'Question'

  def is_sendable?
    first_question.present?
  end

  def welcome_message
    # TODO (Chris): Ensure Nick implements this function
    name
  end

  def was_sent?
    survey_execution_states.present?
  end

  def welcome_message
    'Welcome to one of Somo\'s surveys!'
  end

  def finished_message
    'Thanks for completing the survey!'
  end

  def generate_models
    self.update!(
      name: parameters['name'],
      description: parameters['description'],
    )

    questions = generate_questions_and_response_choices(parameters['questions'])
    self.update!(first_question: questions[1])

    parameters['questions'].each do |question_params|
      if (question_params['default_next_question_id'].to_i == -1)
        question_params['options'].each do |response_params|
          if (questions.keys.include? response_params['next_question_id'])
            ConditionalQuestionOrder.create!(
              question: questions[question_params['id']],
              response_choice: questions[question_params['id']].response_choices.find_by_key(response_params['key']),
              next_question: questions[response_params['next_question_id']]
            )
          end
        end
      else
        if (questions.keys.include? question_params['default_next_question_id'])
          DefaultQuestionOrder.create!(
            question: questions[question_params['id']],
            next_question: questions[question_params['default_next_question_id']]
          )
        end
      end
    end
  end

private

  def generate_questions_and_response_choices(params)
    questions = params.map do |question_params|
      question = Question.create!(
        survey: self,
        text: question_params['text'],
        question_type: question_params['question_type'].downcase,
        number: question_params['id'],
      )

      question_params['options'].each do |response_params|
        ResponseChoice.create!(
          question: question,
          key: response_params['key'].downcase,
          text: response_params['text'],
        )
      end

      [
        question_params['id'],
        question
      ]
    end

    questions.to_h
  end
end
