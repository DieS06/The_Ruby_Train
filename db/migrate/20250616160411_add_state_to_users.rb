class AddStateToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :state, :string, default: "pending", null: false
  end
end
