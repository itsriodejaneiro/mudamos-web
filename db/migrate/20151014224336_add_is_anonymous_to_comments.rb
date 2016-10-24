class AddIsAnonymousToComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_anonymous, :boolean
  end
end
