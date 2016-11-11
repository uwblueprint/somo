class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text            :text
      t.timestamps null: false
    end

    create_table :response_choices do |t|
      t.belongs_to      :questions, index: true
      t.string          :key
      t.text            :text

      t.timestamps null: false
    end

    create_table :question_orders do |t|
      t.belongs_to      :survey, index: true, foreign_key: true
      t.references      :question, index: true
      t.references      :next_question, references: :questions, index: true
      t.references      :response_choice, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :question_orders, :questions, column: :question_id
    add_foreign_key :question_orders, :questions, column: :next_question_id
  end
end
