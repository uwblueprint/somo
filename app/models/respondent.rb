# == Schema Information
#
# Table name: respondents
#
#  id                                   :integer          not null, primary key
#  name                                 :string
#  phone_number                         :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Respondent < ActiveRecord::Base
  has_many :survey_responses
  has_many :responses
  has_many :survey_execution_states

  # Normalizes the attribute itself before validation
  phony_normalize :phone_number

  validates_plausible_phone :phone_number, presence: true
  validates_uniqueness_of :phone_number

  def accepting_surveys?
    survey_execution_states.where.not(status: SurveyExecutionState.statuses[:finished]).empty?
  end
end
