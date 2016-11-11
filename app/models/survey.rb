# == Schema Information
#
# Table name: surveys
#
#  id                                   :integer          not null, primary key
#  name                                 :string
#  description                          :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Survey < ActiveRecord::Base
  has_many :question_orders
  has_many :survey_responses

  validates :description, :name, presence: true
end
