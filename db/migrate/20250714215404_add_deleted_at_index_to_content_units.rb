class AddDeletedAtIndexToContentUnits < ActiveRecord::Migration[8.0]
  def change
    add_index :content_units, :deleted_at
  end
end
