# frozen_string_literal: true

# == ProgressType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing a user's progress across content units.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier
# @!attribute [r] user_id
#   @return [ID] ID of the user
# @!attribute [r] content_unit_id
#   @return [ID] ID of the related content unit (lesson, segment, etc.)
# @!attribute [r] progress_percentage
#   @return [Integer] Percentage of completion (0–100)
# @!attribute [r] last_accessed_at
#   @return [ISO8601DateTime, nil] Timestamp of last access
# @!attribute [r] created_at
#   @return [ISO8601DateTime] Record creation time
# @!attribute [r] updated_at
#   @return [ISO8601DateTime] Record update time
#
# === Associations
# @!attribute [r] user
#   @return [UserType] The user associated with the progress
# @!attribute [r] content_unit
#   @return [ContentUnitUnion] The content unit being tracked
#
# @see Progress
#
# @!endgroup
#

module Types
  class ProgressType < Types::BaseObject
    description "Represents a user's progress for a given content unit"

    field :id, ID, null: false
    field :user_id, ID, null: false
    field :content_unit_id, ID, null: false
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true, description: "Timestamp when the content unit was completed"
    field :score, Integer, null: true, description: "Score achieved in the content unit (if applicable)"
    field :state, String, null: false, description: "Current state of the content unit (e.g., in_progress, completed, failed)"

    field :progress_percentage, Integer, null: false
    field :last_accessed_at, GraphQL::Types::ISO8601DateTime, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    field :content_unit, Types::ContentUnit::ContentUnitUnion, null: false
  end
end
