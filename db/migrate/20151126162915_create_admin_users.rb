class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :name
      t.string :password
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
