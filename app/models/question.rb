# == Schema Information
#
# Table name: questions
#
#  id                                   :integer          not null, primary key
#  text                                 :text
#  number                               :integer
#  question_type                        :string
#  survey_id                            :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Question < ActiveRecord::Base
  has_many :question_orders, inverse_of: :question
  has_many :responses
  has_many :response_choices

  belongs_to :survey

  validates :text, presence: true
  validates :number, presence: true, numericality: { only_integer: true }
  validates :question_type, presence: true, inclusion: {in: %w[short_answer multiple_choice true_false]}

  def formatted_question_and_responses
    # TODO (Chris) will implement later since it's pretty complex
    # involves getting the responses too
    text
  end

  def is_response_valid?(response)
    if response_choices.exists?
      return response_choices.map(&:key).include? response.answer
    else
      true
    end
  end

  def next_question(response)
    if response_choices.exists?
      response_choices.each do |response_choice|
        if response_choice.question_order.present? && response_choice.key == response.answer
          return response_choice.question_order.next_question
        end
      end
    elsif question_orders.exists?
      return question_orders.first.next_question
    end
    nil
  end
end
