class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, primary_key: "guid", id: :string do |t|
      t.timestamps
    end
  end
end
