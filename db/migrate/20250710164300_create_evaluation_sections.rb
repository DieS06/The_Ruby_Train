class CreateEvaluationSections < ActiveRecord::Migration[8.0]
  def change
    create_table :evaluation_sections do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: true
      t.integer :position, null: false, default: 0
      t.integer :time_limit, null: true

      t.timestamps
    end
  end
end
