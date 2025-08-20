class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.integer :badge_type
      t.string :three_d_model_url
      t.jsonb :criteria
      t.integer :state


      t.timestamps
    end
  end
end
