class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :name
      t.string :subdomain
      t.string :title
      t.string :about
      t.datetime :initial_date
      t.datetime :final_date
      t.string :slug
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
