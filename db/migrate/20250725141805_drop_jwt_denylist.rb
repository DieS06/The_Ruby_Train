class DropJwtDenylist < ActiveRecord::Migration[8.0]
  def up
    drop_table :jwt_denylists, if_exists: true
  end
  def down
  end
end
