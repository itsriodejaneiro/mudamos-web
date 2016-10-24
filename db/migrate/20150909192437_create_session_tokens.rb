class CreateSessionTokens < ActiveRecord::Migration
  def change
    create_table :session_tokens do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expire_at
      t.string :platform

      t.timestamps null: false
    end
    add_index :session_tokens, :expire_at
  end
end
