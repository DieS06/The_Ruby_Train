# frozen_string_literal: true

# == SubmissionType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for a submission of an evaluation.
#
# === Fields
# * id
# * evaluation_id
# * user_id
# * score
# * state
# * graded
# * created_at
# * updated_at
#
# === Associations
# * evaluation
# * answers
#
# @see Submission
#
# @!endgroup
#

module Types
  class SubmissionType < Types::BaseObject
    description "Submission of a user to a given evaluation"

    field :id, ID, null: false
    field :evaluation_id, ID, null: false
    field :user_id, ID, null: false
    field :submitted_at, GraphQL::Types::ISO8601DateTime, null: true, description: "Timestamp when the submission was made"
    field :score, Integer, null: true
    field :state, String, null: false
    field :feedback, String, null: true, description: "Feedback provided by the evaluator"
    field :manual_review_required, Boolean, null: false, description: "Whether manual review is required for this submission"
    field :graded, Boolean, null: false, method: :graded?

    field :evaluation, Types::Evaluation::EvaluationUnion, null: false
    field :submission_answers, [ Types::SubmissionAnswerType ], null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
