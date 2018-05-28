class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.float :price
      t.integer :list_id
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :items, :lists, column: :list_id
  end
end
