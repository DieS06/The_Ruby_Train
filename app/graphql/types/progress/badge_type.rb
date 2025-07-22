# frozen_string_literal: true

# == BadgeType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing a badge that can be earned by users through achievements.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier
# @!attribute [r] name
#   @return [String] Name of the badge
# @!attribute [r] badge_type
#   @return [String] Type of the badge (e.g., course, ruby, star)
# @!attribute [r] three_d_model_url
#   @return [String, nil] Optional URL to the badge's 3D model
# @!attribute [r] criteria
#   @return [JSON] JSON representation of the badge's evaluation criteria
# @!attribute [r] state
#   @return [String] Current state of the badge (active, retired, hidden)
# @!attribute [r] created_at
#   @return [ISO8601DateTime] Timestamp when the badge was created
# @!attribute [r] updated_at
#   @return [ISO8601DateTime] Timestamp when the badge was last updated
#
# === Associations
# @!attribute [r] user_badges
#   @return [UserBadgeType[]] List of user-badge relationships
#
# @see Badge
#
# @!endgroup

module Types
  class BadgeType < Types::BaseObject
    description "Represents a badge that can be earned by a user"

    field :id, ID, null: false
    field :name, String, null: false
    field :badge_type, String, null: false
    field :three_d_model_url, String, null: true, description: "Optional URL to a 3D model of the badge"
    field :criteria, GraphQL::Types::JSON, null: true, description: "Criteria for earning the badge in JSON format"
    field :state, String, null: false, description: "Current state of the badge (e.g., active, retired)"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user_badges, [ Types::UserBadgeType ], null: true
  end
end
