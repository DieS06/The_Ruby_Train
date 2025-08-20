# frozen_string_literal: true

# frozen_string_literal: true

# == FindEnrollment
#
# @!group 02-GraphQL / Queries / Enrollment
#
# Finds a specific enrollment by ID, only if owned by current user or allowed.
#
# === Arguments
# * `id`: ID of the enrollment
#
# === Returns
# * A single EnrollmentType object or null
#
# === Example
# query {
#   findEnrollment(id: 1) {
#     id
#     progressPercent
#     state
#   }
# }
#
# @!endgroup


module Queries
  module Enrollment
    class FindEnrollment < Queries::BaseQuery
      description "Find an enrollment by ID"

      argument :id, ID, required: true
      type Types::Enrollment::EnrollmentType, null: true

      def resolve(id:)
        enrollment = ::Enrollment.find_by(id: id)
        raise GraphQL::ExecutionError, "Not authorized" unless ability.can?(:read, enrollment)
        enrollment
      end
    end
  end
end
