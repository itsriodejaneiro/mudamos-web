class AddSubProfileIdToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :sub_profile_id, index: true, foreign_key: true
    end
  end
end
