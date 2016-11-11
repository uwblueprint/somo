# == Schema Information
#
# Table name: responses
#
#  id                                   :integer          not null, primary key
#  survey_response_id                   :integer
#  question_id                          :integer
#  respondent_id                        :integer
#  answer                               :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Response < ActiveRecord::Base
  belongs_to :survey_response
  belongs_to :respondent
  belongs_to :question

  validates :answer, presence: true
end
