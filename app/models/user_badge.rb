# frozen_string_literal: true

# == UserBadge
#
# Represents the link between a User and a Badge, indicating when it was awarded.
#
# === Attributes
# @!attribute [rw] user_id
#   @return [Integer] Reference to the user who earned the badge
# @!attribute [rw] badge_id
#   @return [Integer] Reference to the awarded badge
# @!attribute [rw] awarded_at
#   @return [DateTime] Date and time when the badge was awarded
#
# === Associations
# * Belongs to a User
# * Belongs to a Badge
#
# === Example
#   UserBadge.award_badge(current_user, Badge.first)
#

class UserBadge < ApplicationRecord
  include PublicActivity::Model
  tracked owner: :user

  belongs_to :user
  belongs_to :badge

  validates :user, presence: true
  validates :badge, presence: true
  validates :awarded_at, presence: true

  def self.award_badge(user, badge)
    return if user.badges.exists?(badge.id)

    user_badge = create(user: user, badge: badge, awarded_at: Time.current)
    user_badge.create_activity key: "badge.awarded", owner: user

    BadgeAwardedNotifier.with(badge: badge).deliver_later(user)

    user_badge
  end

  def update_progresses
    progresses.each do |progress|
      progress.update(state: :awarded) if progress.state == "passed"
    end
  end
end
