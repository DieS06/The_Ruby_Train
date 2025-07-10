class CreateAnswerOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :answer_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :option_text, null: false
      t.boolean :is_correct, null: false, default: false
      t.text :explanation, null: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
