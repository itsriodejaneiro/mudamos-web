class CreateSubjectsUsers < ActiveRecord::Migration
  def change
    create_table :subjects_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true
      t.boolean :agree, default: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :subjects_users, :deleted_at
  end
end
