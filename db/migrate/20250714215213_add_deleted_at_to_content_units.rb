class AddDeletedAtToContentUnits < ActiveRecord::Migration[8.0]
  def change
    add_column :content_units, :deleted_at, :datetime
  end
end
