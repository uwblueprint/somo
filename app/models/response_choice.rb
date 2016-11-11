# == Schema Information
#
# Table name: response_choices
#
#  id                                   :integer          not null, primary key
#  question_id                          :integer
#  key                                  :string
#  text                                 :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class ResponseChoice < ActiveRecord::Base
  belongs_to :question
  has_one :question_order

  validates :key, presence: true, inclusion: {in: %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]}
end
