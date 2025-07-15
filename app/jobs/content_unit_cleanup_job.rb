class ContentUnitCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
   ContentUnit.where(state: :deleted)
              .where("deleted_at <= ?", 31.days.ago)
              .find_each do |content_unit|
      content_unit.really_destroy!
    end
  end
end
