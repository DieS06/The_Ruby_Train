# frozen_string_literal: true

# == BadgeAssigner
#
# Service object that evaluates and assigns all eligible active badges to a given user.
# It compares each badge's `criteria` field (a JSON structure) against the user's progress.
#
# === Usage
#   BadgeAssigner.new(user).call
#
# === Example
#   BadgeAssigner.new(current_user).call
#

class BadgeAssigner
  def initialize(user)
    @user = user
  end

  def call
    Badge.active_badges.find_each do |badge|
      next if @user.badges.include?(badge)

      if BadgeCriteriaEvaluator.new(user: @user, badge: badge).satisfied?
        UserBadge.award_badge(@user, badge)
      end
    end
  end
end
