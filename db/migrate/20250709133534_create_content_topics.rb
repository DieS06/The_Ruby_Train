class CreateContentTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :content_topics do |t|
      t.references :content_unit, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.integer :relevance, null: true, default: 1
      t.integer :state, null: false, default: 0

      t.timestamps
    end

    add_index :content_topics, [ :content_unit_id, :topic_id ], unique: true
  end
end
