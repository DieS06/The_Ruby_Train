class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :name, null: false
      t.text :description, null: true
      t.integer :position, null: false, default: 0
      t.bigint :parent_id, null: true, index: true
      t.integer :state, null: false, default: 0

      t.timestamps
    end

    add_index :topics, :name, unique: true
    add_foreign_key :topics, :topics, column: :parent_id
  end
end
