class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_attachment :users, :picture
  end
end
