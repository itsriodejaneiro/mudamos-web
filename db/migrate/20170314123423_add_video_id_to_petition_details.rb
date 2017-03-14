class AddVideoIdToPetitionDetails < ActiveRecord::Migration
  def change
    add_column :petition_plugin_details, :video_id, :string
  end
end
