class CreateAliasNames < ActiveRecord::Migration
  def change
    create_table :alias_names do |t|
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
