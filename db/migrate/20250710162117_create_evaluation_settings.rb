class CreateEvaluationSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :evaluation_settings do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.integer :attempts_allowed, null: true, default: 1
      t.boolean :shuffle_questions, null: false, default: true
      t.boolean :show_results, null: false, default: false
      t.boolean :show_feedback, null: false, default: false
      t.jsonb :config

      t.timestamps
    end
  end
end
