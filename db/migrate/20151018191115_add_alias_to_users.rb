class AddAliasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alias_as_default, :boolean, default: false
    add_column :users, :alias_name, :string
  end
end
