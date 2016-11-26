class AddFirstQuestionToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :first_question_id, :integer
  end
end
