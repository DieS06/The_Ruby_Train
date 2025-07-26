# frozen_string_literal: true

# == FindEvaluation Resolver
#
# @!group 02-GraphQL / Resolvers
#
# Fetches a single Evaluation by ID.
#
# === Arguments
# @param id [ID] The ID of the evaluation
#
# === Returns
# @return [Types::Evaluation::EvaluationInterface] A Quiz or Exam object implementing the interface
#
# === Authorization
# * Only users with visibility can access the evaluation
#
# === Example
# query {
#   evaluation(id: 1) {
#     id
#     title
#     ... on QuizType { totalQuestions }
#     ... on ExamType { sectionsCount }
#   }
# }
#
# @!endgroup
#

module Queries
  module Evaluation
    class FindEvaluation < Queries::BaseQuery
      type Types::Interfaces::EvaluationInterface, null: false
      argument :id, ID, required: true

      def resolve(id:)
        record = ::Evaluation.find(id)
        raise CanCan::AccessDenied unless record.visible_for?(context[:current_user])
        record
      end
    end
  end
end
