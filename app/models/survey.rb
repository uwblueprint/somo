# == Schema Information
#
# Table name: surveys
#
#  id                                   :integer          not null, primary key
#  name                                 :string
#  description                          :text
#  first_question_id                    :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Survey < ActiveRecord::Base
  has_many :question_orders
  has_many :survey_responses

  belongs_to :first_question, foreign_key: :first_question_id, class_name: 'Question'

  validates :description, :name, presence: true

  def is_sendable?
    return !first_question.nil?
  end
end
