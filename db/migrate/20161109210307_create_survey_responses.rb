class CreateSurveyResponses < ActiveRecord::Migration
  def change
    create_table :survey_responses do |t|
      t.references :survey, index: true, foreign_key: true
      t.references :respondent, index: true, foreign_key: true
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
