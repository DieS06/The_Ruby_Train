class CreateGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :group_memberships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :joined_at
      t.bigint :invited_by
      t.string :invited_token
      t.integer :state, null: false, default: 0

      t.timestamps
    end

    add_index :group_memberships, [ :group_id, :user_id ], unique: true
    add_foreign_key :group_memberships, :users, column: :invited_by
  end
end
