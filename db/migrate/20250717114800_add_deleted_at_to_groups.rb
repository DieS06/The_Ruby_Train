class AddDeletedAtToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :deleted_at, :datetime, null: true, comment: "Timestamp for soft deletion of groups"
    add_index :groups, :deleted_at
  end
end
