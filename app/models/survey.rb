# == Schema Information
#
# Table name: surveys
#
#  id                                   :integer          not null, primary key
#  name                                 :string
#  description                          :text
#  first_question_id                    :integer
#  survey_id                            :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Survey < ActiveRecord::Base
  has_many :questions
  has_many :survey_responses

  belongs_to :first_question, foreign_key: :first_question_id, class_name: 'Question'

  validates :description, :name, presence: true

  def is_sendable?
    return !first_question.nil?
  end

  def to_csv
    # Column headers: respondent-name, respondent-phone, question1, question2, etc 
    attributes = %w{name phone-number}.concat questions.collect{|q| q.text}
    puts attributes
    CSV.generate(headers: true) do |csv|
      csv << attributes
      survey_responses.each do |sur_resp|
        puts sur_resp.respondent.name
        #csv << [sur_resp.respondent.name, sur_resp.respondent.phone_number].concat sur_resp.responses.collect{|r| r.text}
      end
    end
  end
end
