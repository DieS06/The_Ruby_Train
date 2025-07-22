class RenameProgressesToProgress < ActiveRecord::Migration[8.0]
  def change
    rename_table :progresses, :progress
  end
end
