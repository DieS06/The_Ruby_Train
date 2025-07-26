# frozen_string_literal: true

# == CreateQuestion
#
# @!group 02-GraphQL / Mutations
#
# Mutation to create a Question within an Evaluation or Section.
#
# === Arguments
# @param evaluation_id [ID]
# @param evaluation_section_id [ID]
# @param topic_id [ID]
# @param statement [String]
# @param question_type [String]
# @param position [Integer]
# @param explanation [String]
# @param points [Integer]
#
# === Returns
# @return [Types::Evaluation::QuestionType]
#
# === Example
# mutation {
#   createQuestion(input: {
#     evaluationId: 1,
#     statement: "What is Ruby?",
#     questionType: "single_choice",
#     position: 1,
#     points: 5
#   }) {
#     question {
#       id
#       statement
#     }
#     errors
#   }
# }
#
# @!endgroup
#

module Mutations
  module Evaluation
    class CreateQuestion < Base::BaseMutation
      graphql_name "CreateQuestion"

      argument :evaluation_id, ID, required: true
      argument :evaluation_section_id, ID, required: false
      argument :topic_id, ID, required: false
      argument :statement, String, required: true
      argument :question_type, String, required: true
      argument :position, Integer, required: true
      argument :explanation, String, required: false
      argument :points, Integer, required: true
      argument :created_by, ID, required: false

      argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
      argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false

      field :question, Types::Evaluation::QuestionType, null: true
      field :errors, [ String ], null: false

      def resolve(**attrs)
        evaluation = ::Evaluation.find(attrs[:evaluation_id])

        if evaluation.is_a?(Evaluations::Exam) && attrs[:evaluation_section_id].blank?
          return { question: nil, errors: [ "Evaluation section is required for exams" ] }
        end

        attrs[:created_by] ||= context[:current_user].id

        question = ::Question.new(
          attrs.merge(
            evaluation_section_id: attrs[:evaluation_section_id].presence,
            topic_id: attrs[:topic_id].presence
          )
        )

        if question.save
          { question:, errors: [] }
        else
          { question: nil, errors: question.errors.full_messages }
        end
      end
    end
  end
end
