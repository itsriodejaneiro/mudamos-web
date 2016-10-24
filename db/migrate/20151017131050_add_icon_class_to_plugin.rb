class AddIconClassToPlugin < ActiveRecord::Migration
  def change
    add_column :plugins, :icon_class, :string
  end
end
