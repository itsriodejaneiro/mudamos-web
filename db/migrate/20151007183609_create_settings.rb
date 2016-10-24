class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
