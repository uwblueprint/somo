# == Schema Information
#
# Table name: questions
#
#  id                                   :integer          not null, primary key
#  text                                 :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  question_type                        :string
#

class Question < ActiveRecord::Base
  has_one :question_order
  has_one :survey
  has_many :responses
  has_many :response_choices

  validates :text, presence: true

  validates :question_type, presence: true, inclusion: {in: %w[short_answer mc checkbox t_or_f]}
end
