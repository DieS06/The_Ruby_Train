class PurgeSuspendedUsersJob < ApplicationJob
  queue_as :default

  def perform
    threshold = 30.days.ago
    User.suspended.where('updated_at < ?', threshold).find_each do |user|
      user.destroy!
    end
  end
end
