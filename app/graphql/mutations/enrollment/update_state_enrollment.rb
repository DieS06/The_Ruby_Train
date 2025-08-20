# frozen_string_literal: true

# == updateEnrollmentState
#
# @!group 02-GraphQL / Enrollment
#
# Updates the state of an enrollment (pending, active, completed, withdrawn)
#
# === Arguments
# * `id`: ID of the enrollment
# * `state`: String with new state (enum)
#
# === Returns
# * `enrollment`: The updated enrollment object
# * `errors`: Array of error messages
#
# === Example
# mutation {
#   updateEnrollmentState(id: 1, state: "active") {
#     enrollment { id state }
#     errors
#   }
# }
#
# @!endgroup
#

module Mutations
  module Enrollment
    class UpdateStateEnrollment < Mutations::Base::BaseMutation
      description "Update the state of an enrollment (e.g., from pending to active)"

      argument :id, ID, required: true
      argument :state, String, required: true

      field :enrollment, Types::Enrollment::EnrollmentType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, state:)
        user = context[:current_user]
        raise GraphQL::ExecutionError, "Authentication required." unless user

        enrollment = ::Enrollment.find_by(id: id)
        raise GraphQL::ExecutionError, "Enrollment not found." unless enrollment
        raise GraphQL::ExecutionError, "Not authorized" unless ability.can?(:update, enrollment)

        if ::Enrollment.states.key?(state)
          enrollment.state = state
          if enrollment.save
            { enrollment: enrollment, errors: [] }
          else
            { enrollment: nil, errors: enrollment.errors.full_messages }
          end
        else
          { enrollment: nil, errors: [ "Invalid state: #{state}" ] }
        end
      end
    end
  end
end
