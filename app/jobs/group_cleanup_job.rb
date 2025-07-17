class GroupCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Group.expired_deletions.find_each(&:destroy!)
  end
end
