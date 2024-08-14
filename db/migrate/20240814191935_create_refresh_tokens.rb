class CreateRefreshTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :refresh_tokens do |t|
      t.string :refresh_token_hash
      t.string :ip, null: false
      t.string :user_guid, null: false
      t.datetime :expire, null: false
      t.timestamps
    end

    add_foreign_key :refresh_tokens, :users, column: :user_guid, primary_key: :guid
  end
end
