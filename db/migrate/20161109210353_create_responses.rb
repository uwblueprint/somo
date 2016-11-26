class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :survey_response, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.references :respondent, index: true, foreign_key: true
      t.text :answer

      t.timestamps null: false
    end
  end
end
