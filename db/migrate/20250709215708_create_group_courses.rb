class CreateGroupCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :group_courses do |t|
      t.references :group, null: false, foreign_key: true
      t.references :content_unit, null: false, foreign_key: true
      t.datetime :assigned_at, null: false
      t.integer :state, null: false, default: 0

      t.timestamps
    end

    add_index :group_courses, [ :group_id, :content_unit_id ], unique: true
  end
end
