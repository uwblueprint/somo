class AddUniqueIndexToPhoneNumbers < ActiveRecord::Migration
  def change
    remove_index :respondents, :phone_number
    add_index :respondents, :phone_number, :unique => true
  end
end
