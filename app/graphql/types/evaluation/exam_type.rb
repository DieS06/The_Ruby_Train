# frozen_string_literal: true

# == ExamType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing an Exam evaluation.
#
# Implements EvaluationInterface and inherits all shared fields.
#
# @example
# query {
#   evaluation(id: 2) {
#     ... on Exam {
#       title
#       totalPoints
#     }
#   }
# }
#
# @!endgroup
#

module Types
  module Evaluation
    class ExamType < Types::BaseObject
      implements Interfaces::EvaluationInterface

      description "Exam evaluation object type"
    end
  end
end
