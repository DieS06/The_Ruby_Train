# frozen_string_literal: true

# == ListEvaluations Resolver
#
# @!group 02-GraphQL / Resolvers
#
# Lists all evaluations visible to the current user.
#
# === Returns
# @return [Array<Types::Evaluation::EvaluationInterface>] All evaluations (quizzes or exams)
#
# === Authorization
# * Admins see all evaluations
# * Other users see their own or visible ones
#
# === Example
# query {
#   evaluations {
#     id
#     title
#     ... on QuizType { totalQuestions }
#   }
# }
#
# @!endgroup
#

module Queries
  module Evaluation
    class ListEvaluations < Queries::BaseResolver
      type [ Types::Interfaces::EvaluationInterface ], null: false

      def resolve
        user = context[:current_user]
        if user.has_role?(:admin) || user.has_role?(:super_admin)
          ::Evaluation.all
        else
          ::Evaluation.visible.or(::Evaluation.where(created_by: user.id))
        end
      end
    end
  end
end
