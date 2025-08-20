class CreateEvaluations < ActiveRecord::Migration[8.0]
  def change
    create_table :evaluations do |t|
      t.string :type, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.integer :time_limit, null: true
      t.integer :state, null: false, default: 0
      t.references :content_unit, null: false, foreign_key: true
      t.bigint :created_by

      t.timestamps
    end

    add_foreign_key :evaluations, :users, column: :created_by
  end
end
