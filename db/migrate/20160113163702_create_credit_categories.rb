class CreateCreditCategories < ActiveRecord::Migration
  def up
    create_table :credit_categories do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :credit_categories, :deleted_at
  end

  def down
    drop_table :credit_categories
  end
end
