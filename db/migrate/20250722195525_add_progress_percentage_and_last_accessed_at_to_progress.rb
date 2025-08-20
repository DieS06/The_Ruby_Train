class AddProgressPercentageAndLastAccessedAtToProgress < ActiveRecord::Migration[8.0]
  def change
    add_column :progress, :progress_percentage, :integer, default: 0, null: false
    add_column :progress, :last_accessed_at, :datetime
  end
end
