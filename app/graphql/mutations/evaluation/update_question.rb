# frozen_string_literal: true

# == UpdateQuestion
#
# @!group 02-GraphQL / Mutations
#
# Updates a Question. If the current user isn't the creator,
# it clones the question and assigns them as new owner.
#
# === Arguments
# @param id [ID] Question ID
# @param statement [String]
# @param question_type [String]
# @param position [Integer]
# @param explanation [String]
# @param points [Integer]
# @param topic_id [ID]
# @param evaluation_section_id [ID]
#
# === Returns
# @return [Types::Evaluation::QuestionType]
#
# === Example
# mutation {
#   updateQuestion(input: {
#     id: 5,
#     statement: "What is Rails?",
#     explanation: "A Ruby framework"
#   }) {
#     question {
#       id
#       statement
#       createdBy
#     }
#     errors
#   }
# }
#
# @!endgroup
#

module Mutations
  module Evaluation
    class UpdateQuestion < Base::BaseMutation
      graphql_name "UpdateQuestion"

      argument :id, ID, required: true
      argument :evaluation_id, ID, required: false
      argument :evaluation_section_id, ID, required: false
      argument :topic_id, ID, required: false
      argument :statement, String, required: false
      argument :question_type, String, required: false
      argument :position, Integer, required: false
      argument :explanation, String, required: false
      argument :points, Integer, required: false
      argument :created_by, ID, required: false

      argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
      argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false

      field :question, Types::Evaluation::QuestionType, null: true
      field :errors, [ String ], null: false

      def resolve(**attrs)
        user = context[:current_user]
        original = ::Question.find(attrs[:id])

        if original.created_by == user.id
          if original.update(attrs.except(:id, :created_at, :updated_at))
            { question: original, errors: [] }
          else
            { question: nil, errors: original.errors.full_messages }
          end
        else
          new_question = original.dup
          new_question.assign_attributes(attrs.except(:id, :created_at, :updated_at))
          new_question.created_by = user.id
          if new_question.save
            { question: new_question, errors: [] }
          else
            { question: nil, errors: new_question.errors.full_messages }
          end
        end
      end
    end
  end
end
