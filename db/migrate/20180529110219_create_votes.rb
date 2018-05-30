class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :item_id
    end
    add_foreign_key :votes, :users, column: :user_id
    add_foreign_key :votes, :items, column: :item_id
  end
end
