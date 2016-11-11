# == Schema Information
#
# Table name: question_orders
#
#  id                                   :integer          not null, primary key
#  survey_id                            :integer
#  question_id                          :integer
#  next_question_id                     :integer
#  response_choice_id                   :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class QuestionOrder < ActiveRecord::Base
  belongs_to :survey
  belongs_to :next_question, foreign_key: :next_question_id, class_name: 'Question'
  belongs_to :question
end
