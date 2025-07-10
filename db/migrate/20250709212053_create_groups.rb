class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :description, null: true
      t.integer :group_type, null: false
      t.bigint :mentor_id, null: true
      t.bigint :academic_id, null: true
      t.integer :state, null: true, default: 0
      t.string :slug, null: false
      t.timestamps
    end

    add_index :groups, :slug, unique: true
    add_foreign_key :groups, :users, column: :mentor_id
    add_foreign_key :groups, :users, column: :academic_id
  end
end
