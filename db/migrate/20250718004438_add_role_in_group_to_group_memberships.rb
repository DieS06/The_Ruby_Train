class AddRoleInGroupToGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :group_memberships, :role_in_group, :integer
  end
end
