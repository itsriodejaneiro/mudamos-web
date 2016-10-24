class AddIsAnonymousToSubjectUsers < ActiveRecord::Migration
  def change
    add_column :subjects_users, :is_anonymous, :boolean
  end
end
