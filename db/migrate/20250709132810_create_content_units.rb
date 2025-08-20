class CreateContentUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :content_units do |t|
      t.string :type, null: false
      t.bigint :parent_id, null: false
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :state, null: false, default: 0
      t.text :description, null: false
      t.integer :position, null: false
      t.datetime :lock_expire_at, null: false
      t.bigint :created_by, null: false

      t.timestamps
    end

    add_index :content_units, :slug, unique: true
    add_foreign_key :content_units, :content_units, column: :parent_id
  end
end
