class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :evaluation, null: false, foreign_key: true
      t.datetime :submitted_at
      t.integer :score
      t.integer :state
      t.text :feedback

      t.timestamps
    end
  end
end
