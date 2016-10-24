class AddTagToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :title, :string
  end
end
