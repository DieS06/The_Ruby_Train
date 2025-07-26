# frozen_string_literal: true

# == AnswerOptionType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for answer options related to questions.
#
# === Fields
# * id
# * question_id
# * content
# * correct
# * position
# * created_at
# * updated_at
#
# @see Question
#
# @!endgroup
#

module Types
  module Evaluation
    class AnswerOptionType < Types::BaseObject
      description "Option for a multiple choice or true/false question"

      field :id, ID, null: false
      field :question_id, Integer, null: false
      field :option_text, String, null: false
      field :is_correct, Boolean, null: false
      field :explanation, String, null: true
      field :position, Integer, null: false

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :question, Types::Evaluation::QuestionType, null: false, description: "The question this option belongs to"
    end
  end
end
