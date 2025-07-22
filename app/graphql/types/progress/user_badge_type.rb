# frozen_string_literal: true

# == UserBadgeType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing the assignment of a badge to a user.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier
# @!attribute [r] user_id
#   @return [ID] ID of the user who earned the badge
# @!attribute [r] badge_id
#   @return [ID] ID of the badge earned
# @!attribute [r] awarded_at
#   @return [ISO8601DateTime] Timestamp when the badge was awarded
# @!attribute [r] source_id
#   @return [ID, nil] Optional ID of the source that triggered the badge (e.g., Course, Quiz)
# @!attribute [r] source_type
#   @return [String, nil] Optional type of the source that triggered the badge
# @!attribute [r] created_at
#   @return [ISO8601DateTime] Record creation time
# @!attribute [r] updated_at
#   @return [ISO8601DateTime] Record update time
#
# === Associations
# @!attribute [r] badge
#   @return [BadgeType] The badge object
# @!attribute [r] user
#   @return [UserType] The user who earned the badge
#
# @see UserBadge
#
# @!endgroup
#

module Types
  class UserBadgeType < Types::BaseObject
    description "Represents a badge awarded to a user"

    field :id, ID, null: false
    field :user_id, ID, null: false
    field :badge_id, ID, null: false
    field :awarded_at, GraphQL::Types::ISO8601DateTime, null: false
    field :source_id, ID, null: true, description: "Optional source ID for the badge (e.g., course or achievement)"
    field :source_type, String, null: true, description: "Optional source type for the badge (e.g., Course, Achievement)"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    field :badge, Types::BadgeType, null: false
  end
end
