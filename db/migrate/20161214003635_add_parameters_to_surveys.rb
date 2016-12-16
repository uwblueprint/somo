class AddParametersToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :parameters, :json
  end
end
