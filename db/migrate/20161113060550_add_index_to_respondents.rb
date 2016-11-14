class AddIndexToRespondents < ActiveRecord::Migration
  def change
    add_index :respondents, :phone_number
  end
end
