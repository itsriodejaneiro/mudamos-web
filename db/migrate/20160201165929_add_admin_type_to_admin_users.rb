class AddAdminTypeToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :admin_type, :integer, default: 0
  end
end
