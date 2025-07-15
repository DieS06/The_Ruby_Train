class FixNullConstraintsOnContentUnits < ActiveRecord::Migration[8.0]
  def change
    change_column_null :content_units, :parent_id, true
    change_column_null :content_units, :lock_expire_at, true
    change_column_null :content_units, :deleted_at, true
  end
end
