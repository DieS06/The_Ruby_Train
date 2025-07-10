class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :content_unit, null: false, foreign_key: true
      t.datetime :enrolled_at, null: false
      t.integer :state, null: false, default: 0
      t.decimal :progress_percent, precision: 5, scale: 2, null: false, default: 0.0

      t.timestamps
    end

    add_index :enrollments, [ :user_id, :content_unit_id ], unique: true
  end
end
