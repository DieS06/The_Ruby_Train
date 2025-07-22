# frozen_string_literal: true

# == CreateQuestion
#
# @!group 02-GraphQL / Mutations
#
# Mutation to create a Question within an Evaluation or Section.
#
# === Arguments
# @param evaluation_id [ID] The evaluation to attach the question to
# @param evaluation_section_id [ID] Optional section if part of a larger exam
# @param topic_id [ID] Optional topic associated with the question
# @param statement [String] The full question text
# @param question_type [String] One of: single_choice, multiple_choice, true_false, text_input
# @param position [Integer] Order of the question
# @param explanation [String] Optional explanation for the answer
# @param points [Integer] Points assigned to this question
#
# === Returns
# @return [Types::Evaluation::QuestionType] Created question object
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

      field :question, Types::QuestionType, null: true
      field :errors, [ String ], null: false

      def resolve(**attrs)
         question = ::Question.new(
          evaluation_id: args[:evaluation_id],
          evaluation_section_id: args[:evaluation_section_id],
          topic_id: args[:topic_id],
          statement: args[:statement],
          question_type: args[:question_type],
          position: args[:position],
          explanation: args[:explanation],
          points: args[:points]
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
