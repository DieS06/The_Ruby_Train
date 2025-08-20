# frozen_string_literal: true

# == QuizType
#
# @!group 02-GraphQL / Types
#
# GraphQL type representing a Quiz evaluation.
#
# Implements EvaluationInterface and inherits all shared fields.
#
# @example
# query {
#   evaluation(id: 1) {
#     ... on Quiz {
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
    class QuizType < Types::BaseObject
      implements Interfaces::EvaluationInterface

      description "Quiz evaluation object type"
    end
  end
end
