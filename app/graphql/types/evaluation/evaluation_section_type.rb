# frozen_string_literal: true

# == EvaluationSectionType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for sections within an evaluation (only for Exams).
#
# === Fields
# * id
# * title
# * description
# * position
# * evaluation_id
# * created_at
# * updated_at
#
# === Associations
# * questions
#
# @see Evaluation
#
# @!endgroup
#

module Types
  class EvaluationSectionType < Types::BaseObject
    description "Section of an evaluation, typically used in exams"

    field :id, ID, null: false
    field :evaluation_id, Integer, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :position, Integer, null: false
    field :time_limit, Integer, null: true, description: "Time limit in seconds for this section"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :questions, [ Types::QuestionType ], null: false
  end
end
