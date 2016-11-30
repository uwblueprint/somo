class AddStatusToSurveyExecutionState < ActiveRecord::Migration
  def change
    add_column :survey_execution_states, :status, :integer, :default => 0
  end
end
