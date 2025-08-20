class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.references :evaluation_section, null: false, foreign_key: true
      t.references :topic, foreign_key: true, null: true
      t.text :statement, null: false
      t.integer :question_type, null: false
      t.integer :position, null: false
      t.text :explanation, null: true
      t.integer :points, null: false, default: 1

      t.timestamps
    end
  end
end
