# frozen_string_literal: true

# == EvaluationUnion
#
# @!group 02-GraphQL / Types
#
# GraphQL union for evaluating different evaluation types (Quiz, Exam).
#
# @example
# query {
#   evaluation(id: 1) {
#     ... on Quiz {
#       title
#     }
#     ... on Exam {
#       title
#     }
#   }
# }
#
# @!endgroup
#
module Types
  module Evaluation
    class EvaluationUnion < Types::BaseUnion
      description "Represents either a Quiz or an Exam evaluation"

      possible_types Types::Evaluation::QuizType, Types::Evaluation::ExamType

      def self.resolve_type(object, _context)
        case object.type
        when "Quiz" then Types::Evaluation::QuizType
        when "Exam" then Types::Evaluation::ExamType
        else
          raise GraphQL::ExecutionError, "Unknown Evaluation type: #{object.type}"
        end
      end
    end
  end
end
