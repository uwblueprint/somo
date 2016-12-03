class AddSurveyToQuestions < ActiveRecord::Migration
  def change
    remove_column :question_orders, :survey_id, :integer
    add_reference :questions, :survey, index: true, foreign_key: true
  end
end
