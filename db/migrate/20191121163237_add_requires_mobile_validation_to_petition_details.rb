class AddRequiresMobileValidationToPetitionDetails < ActiveRecord::Migration
  def change
    add_column :petition_plugin_details, :requires_mobile_validation, :boolean, default: false, null: false
  end
end
