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

  # Normalizes the attribute itself before validation
  phony_normalize :phone_number

  validates_plausible_phone :phone_number, presence: true
end
