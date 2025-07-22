# frozen_string_literal: true

# == QuestionType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for the Question model, representing a single question
# inside an evaluation or evaluation section.
#
# === Fields
# @field id [ID] Question ID
# @field statement [String] Text of the question
# @field question_type [String] Type of the question: single_choice, multiple_choice, etc.
# @field explanation [String] Optional explanation text
# @field position [Integer] Position within the evaluation or section
# @field points [Integer] Points assigned to the question
# @field evaluation_id [ID] ID of the parent evaluation
# @field evaluation_section_id [ID, nil] ID of the optional section (nullable)
# @field topic_id [ID, nil] Associated topic (nullable)
# @field created_at [ISO8601DateTime] Creation timestamp
# @field updated_at [ISO8601DateTime] Update timestamp
#
# === Relations
# @field evaluation [EvaluationUnion] Parent evaluation (Quiz or Exam)
# @field topic [TopicType] Associated topic
# @field answer_options [AnswerOptionType[]] Possible answers (if applicable)
#
# @!endgroup
#

module Types
  class QuestionType < Types::BaseObject
    description "A single question in an evaluation or section"

    field :id, ID, null: false
    field :statement, String, null: false
    field :question_type, String, null: false
    field :position, Integer, null: false
    field :explanation, String, null: true
    field :points, Integer, null: false

    field :evaluation_id, ID, null: false
    field :evaluation_section_id, ID, null: true
    field :topic_id, ID, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :evaluation, Types::Evaluation::EvaluationUnion, null: false
    field :topic, Types::TopicType, null: true
    field :answer_options, [ Types::AnswerOptionType ], null: false
  end
end
