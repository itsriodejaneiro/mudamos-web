class AddScopeCoverageAndCityToPetitionPluginDetail < ActiveRecord::Migration
  def change
    add_reference :petition_plugin_details, :city, index: true
    add_foreign_key :petition_plugin_details, :cities, on_delete: :restrict

    add_column :petition_plugin_details, :scope_coverage, :string, null: false, default: "nationwide"
    add_index :petition_plugin_details, :scope_coverage
    add_column :petition_plugin_details, :uf, :string
    add_index :petition_plugin_details, %i(scope_coverage uf)
  end
end
