class CreateRespondents < ActiveRecord::Migration
  def change
    create_table :respondents do |t|
      t.string :name
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
