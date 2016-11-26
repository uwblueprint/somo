class CreateSurveyExecutionStates < ActiveRecord::Migration
  def change
    create_table :survey_execution_states do |t|
      t.references :respondent, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.references :survey, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
