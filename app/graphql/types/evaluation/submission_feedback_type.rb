# frozen_string_literal: true

# == SubmissionFeedbackType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for exposing feedback or evaluation review for a submission.
#
# === Fields
# @!attribute [r] submission_id
#   @return [ID] Associated submission
# @!attribute [r] general_feedback
#   @return [String] General feedback left by reviewer
# @!attribute [r] score
#   @return [Integer] Final score (optional)
# @!attribute [r] state
#   @return [String] Current state of the submission
# @!attribute [r] submitted_at
#   @return [ISO8601DateTime] Submission timestamp
# @!attribute [r] graded
#   @return [Boolean] If submission has been graded
#
# === Relations
# @!attribute [r] submission
#   @return [SubmissionType]
#
# @!endgroup
#

module Types
  class SubmissionFeedbackType < Types::BaseObject
    description "Feedback and summary for a user submission"

    field :submission_id, ID, null: false
    field :general_feedback, String, null: true
    field :score, Integer, null: true
    field :state, String, null: false
    field :submitted_at, GraphQL::Types::ISO8601DateTime, null: true
    field :graded, Boolean, null: false, method: :graded?

    field :submission, Types::SubmissionType, null: false
  end
end
