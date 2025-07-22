# frozen_string_literal: true

# == Badge
#
# Represents a reward that can be earned by completing specific actions,
# such as lessons, quizzes, modules, or achievements.
#
# === Attributes
# @!attribute [rw] name
#   @return [String] Display name of the badge
# @!attribute [rw] badge_type
#   @return [Integer] Enum: lesson: 0, quiz: 1, module: 2, trophy: 3, silver: 4
# @!attribute [rw] three_d_model_url
#   @return [String, nil] Optional URL to the 3D representation of the badge
# @!attribute [rw] criteria
#   @return [JSON] Badge requirements, dynamically evaluated
# @!attribute [rw] state
#   @return [Integer] Enum: inactive: 0, active: 1, awarded: 2
#
# === Associations
# * Has many UserBadges
# * Has many Users through UserBadges
#
# === Scopes
# * .active_badges — all badges in active state
# * .awarded_badges — all badges already awarded
#

class Badge < ApplicationRecord
  enum :badge_type, {
    lesson: 0,
    quiz: 1,
    module: 2,
    trophy: 3,
    silver: 4
  }

  enum :state, {
    inactive: 0,
    active: 1,
    awarded: 2
  }

  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, presence: true, uniqueness: true
  validates :badge_type, presence: true, inclusion: { in: Badge.badge_types.keys }
  validates :state, presence: true, inclusion: { in: Badge.states.keys }
  validates :criteria, presence: true
  validates :three_d_model_url, allow_nil: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def self.active_badges
    where(state: :active)
  end

  def self.awarded_badges
    where(state: :awarded)
  end

  def self.award_to_user(user, criteria = {})
    badge = find_by(criteria: criteria)
    return unless badge && badge.active?

    UserBadge.award_badge(user, badge)
  end
end
