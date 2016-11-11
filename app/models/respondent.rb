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

  validates :name, :phone_number, presence: true
end
