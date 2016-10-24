class AddFileToSubjects < ActiveRecord::Migration
  def change
    add_attachment :subjects, :file
  end
end
