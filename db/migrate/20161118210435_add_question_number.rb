class AddQuestionNumber < ActiveRecord::Migration
  def change
    add_column :questions, :number, :integer
    add_index :questions, :number
  end
end
