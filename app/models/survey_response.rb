# == Schema Information
#
# Table name: survey_responses
#
#  id                                   :integer          not null, primary key
#  survey_id                            :integer
#  completed_at                         :datetime
#  respondent_id                        :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class SurveyResponse < ActiveRecord::Base
  has_many :responses
  belongs_to :survey
  belongs_to :respondent
end
