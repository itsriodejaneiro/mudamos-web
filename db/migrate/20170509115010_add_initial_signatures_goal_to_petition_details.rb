class AddInitialSignaturesGoalToPetitionDetails < ActiveRecord::Migration
  def change
    add_column :petition_plugin_details, :initial_signatures_goal, :integer, null: false, default: 10_000
  end
end
