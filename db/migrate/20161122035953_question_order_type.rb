class QuestionOrderType < ActiveRecord::Migration
  def change
    add_column :question_orders, :type, :string, null: false
  end
end
