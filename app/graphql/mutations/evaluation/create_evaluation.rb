# frozen_string_literal: true

# == CreateOrUpdateEvaluation Mutation
#
# @!group 03-GraphQL / Mutations
#
# Creates or updates an Evaluation via GraphQL using EvaluationService.
#
# === Arguments
# @param id [ID] Optional ID for updating existing evaluation
# @param title [String] Title of the evaluation
# @param description [String] Optional description
# @param type [String] Type of evaluation: "quiz" or "exam"
# @param time_limit [Integer] Optional time limit in minutes
# @param state [String] One of: draft, visible, archived, hidden
# @param content_unit_id [ID] ContentUnit to associate with
#
# === Returns
# @return [Types::Evaluation::EvaluationType] The resulting evaluation object
#
# === Authorization
# * Only the creator or authorized roles can create/update
#
# @example
# mutation {
#   createEvaluation(
#     title: "Quiz 1",
#     type: "quiz",
#     state: "draft",
#     contentUnitId: 1
#   ) {
#     id
#     title
#     state
#   }
# }
#
# @!endgroup
#

module Mutations
  module Evaluation
    class CreateEvaluation < Mutations::Base::BaseMutation
      argument :id, ID, required: false
      argument :title, String, required: true
      argument :description, String, required: false
      argument :type, String, required: true
      argument :time_limit, Integer, required: false
      argument :state, String, required: true
      argument :content_unit_id, Integer, required: true

      type Types::Evaluation::EvaluationType

      def resolve(**args)
        user = context[:current_user]
        EvaluationService.call(user:, params: args.to_h)
      end
    end
  end
end
