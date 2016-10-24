class CreateOmniauthIdentities < ActiveRecord::Migration
  def change
    create_table :omniauth_identities do |t|
      t.references :user
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
  end
end
