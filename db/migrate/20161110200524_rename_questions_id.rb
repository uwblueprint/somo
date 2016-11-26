class RenameQuestionsId < ActiveRecord::Migration
  def change
    remove_column :response_choices, :questions_id, :integer
    add_reference :response_choices, :question, index: true, foreign_key: true
  end
end
