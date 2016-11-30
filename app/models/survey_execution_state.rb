# == Schema Information
#
# Table name: survey_execution_states
#
#  id                                   :integer          not null, primary key
#  question_id                          :integer
#  respondent_id                        :integer
#  survey_id                            :integer
#  status                               :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class SurveyExecutionState < ActiveRecord::Base
  enum status: [ :initialized, :in_progress, :finished ]
  belongs_to :respondent
  belongs_to :question
  belongs_to :survey

  validates :respondent, :question, :survey, :status, presence: true
end
