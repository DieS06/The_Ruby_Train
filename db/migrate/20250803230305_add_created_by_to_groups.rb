class AddCreatedByToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :created_by, :bigint
    add_index :groups, :created_by
  end
end
