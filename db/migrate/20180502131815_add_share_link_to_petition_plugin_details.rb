class AddShareLinkToPetitionPluginDetails < ActiveRecord::Migration
  def change
    add_column :petition_plugin_details, :share_link, :string
  end
end
