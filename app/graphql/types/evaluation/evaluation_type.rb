# frozen_string_literal: true

# == EvaluationType
#
# @!group 03-GraphQL / Types
#
# GraphQL Type for representing an Evaluation (Quiz or Exam).
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique ID of the evaluation
# @!attribute [r] evaluation_type
#   @return [String] Rails STI type (always "Evaluation")
# @!attribute [r] title
#   @return [String] Title of the evaluation
# @!attribute [r] description
#   @return [String] Optional description
# @!attribute [r] type
#   @return [String] Either "quiz" or "exam"
# @!attribute [r] time_limit
#   @return [Integer] Time limit in minutes
# @!attribute [r] state
#   @return [String] Enum state: draft, visible, archived, hidden
# @!attribute [r] content_unit_id
#   @return [Integer] Associated content unit ID
# @!attribute [r] created_by
#   @return [Integer] Creator's user ID
# @!attribute [r] total_points
#   @return [Integer] Sum of all question points
# @!attribute [r] graded
#   @return [Boolean] True if all submissions are graded
# @!attribute [r] created_at
#   @return [ISO8601DateTime] Timestamp of creation
# @!attribute [r] updated_at
#   @return [ISO8601DateTime] Timestamp of last update
#
# @example Query evaluation with totals
# query {
#   evaluation(id: 1) {
#     title
#     totalPoints
#     graded
#   }
# }
#
# @!endgroup
#

module Types
  module Evaluation
    class EvaluationType < Types::BaseObject
      field :id, ID, null: false
      field :evaluation_type, String, null: false
      field :title, String, null: false
      field :description, String, null: true
      field :time_limit, Integer, null: true
      field :state, String, null: false
      field :content_unit_id, Integer, null: false
      field :created_by, Integer, null: false

      field :total_points, Integer, null: false
      field :graded, Boolean, null: false, method: :graded?
      field :visible_for_current_user, Boolean
      field :duration_minutes, Integer

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      def evaluation_type
        object.type.downcase
      end
    end
  end
end
