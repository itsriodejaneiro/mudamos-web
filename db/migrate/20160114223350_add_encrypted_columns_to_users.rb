class AddEncryptedColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_name, :string
    add_column :users, :encrypted_cpf, :string
    add_column :users, :encrypted_birthday, :string
    add_column :users, :encrypted_state, :string
    add_column :users, :encrypted_city, :string
    add_column :users, :encrypted_alias_name, :string
    add_column :users, :encrypted_email, :string
  end
end
