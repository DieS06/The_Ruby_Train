# frozen_string_literal: true

# == DeleteEvaluation Mutation
#
# @!group 03-GraphQL / Mutations
#
# Deletes an Evaluation by ID.
#
# === Arguments
# @param id [ID] Required ID of the evaluation to delete
#
# === Returns
# @return [Boolean] True if deletion succeeded
#
# === Authorization
# * Only the creator or admins/mentors can delete evaluations
#
# @example
# mutation {
#   deleteEvaluation(id: 1)
# }
#
# @!endgroup
#

module Mutations
  module Evaluation
    class DeleteEvaluation < Mutations::Base::BaseMutation
      argument :id, ID, required: true
      type Boolean

      def resolve(id:)
        user = context[:current_user]
        evaluation = ::Evaluation.find(id)
        raise CanCan::AccessDenied unless Ability.new(user).can?(:destroy, evaluation)

        evaluation.destroy
        true
      end
    end
  end
end
