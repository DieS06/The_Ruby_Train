class CreateProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :content_unit, null: false, foreign_key: true
      t.datetime :completed_at
      t.integer :score
      t.integer :state

      t.timestamps
    end
  end
end
