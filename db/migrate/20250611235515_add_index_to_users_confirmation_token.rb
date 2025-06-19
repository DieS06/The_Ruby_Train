class AddIndexToUsersConfirmationToken < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :confirmation_token, unique: true
  end
end
