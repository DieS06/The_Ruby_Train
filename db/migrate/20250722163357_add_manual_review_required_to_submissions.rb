class AddManualReviewRequiredToSubmissions < ActiveRecord::Migration[8.0]
  def change
    add_column :submissions, :manual_review_required, :boolean, default: false, null: false
  end
end
