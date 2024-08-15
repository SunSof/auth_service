class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, primary_key: "guid", id: :string do |t|
      t.string :email, null: false, index: {unique: true}
      t.timestamps
    end
  end
end
