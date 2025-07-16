class AddCompletedAtToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollments, :completed_at, :datetime
  end
end
