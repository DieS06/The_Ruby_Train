class AddCreatedByToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :created_by, :integer
  end
end
