class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string :title
      t.string :description
      t.boolean :state
      t.bigint :user_id

      t.timestamps
    end
  end
end
