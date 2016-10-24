class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :short_name
      t.string :description
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :profiles, :deleted_at
  end
end
