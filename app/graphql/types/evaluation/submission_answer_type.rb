# frozen_string_literal: true

# == SubmissionAnswerType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing a single answer submitted by a user for a given question
# as part of a submission to an evaluation.
#
# === Fields
# @field id [ID] Unique ID
# @field submission_id [ID] Reference to the submission
# @field question_id [ID] Reference to the question
# @field answer_option_ids [ID[]] Selected answer options (for multiple choice)
# @field text_response [String, nil] Text response if applicable
# @field created_at [ISO8601DateTime] When the answer was created
# @field updated_at [ISO8601DateTime] When the answer was last updated
#
# === Associations
# @field submission [SubmissionType]
# @field question [QuestionType]
# @field answer_options [AnswerOptionType[]]
#
# @see Models::SubmissionAnswer
#
# @!endgroup
#

module Types
  class SubmissionAnswerType < Types::BaseObject
    description "A single answer submitted as part of a user's evaluation submission"

    field :id, ID, null: false
    field :submission_id, ID, null: false
    field :question_id, ID, null: false

    field :answer_option_ids, [ ID ], null: true, description: "IDs of the selected answer options"
    field :text_response, String, null: true, description: "Textual response if the question allows it"
    field :is_correct, Boolean, null: true, description: "Whether the answer is correct (if applicable)"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :submission, Types::SubmissionType, null: false
    field :question, Types::Evaluation::QuestionType, null: false
    field :answer_options, [ Types::AnswerOptionType ], null: true
  end
end
