# frozen_string_literal: true

# == UpdateProgressPercentEnrollment
#
# @!group 02-GraphQL / Enrollment
#
# Updates the progress percentage of an enrollment and marks it as completed if it reaches 100%.
#
# === Arguments
# * `id`: ID of the enrollment
# * `progress_percent`: Float value from 0.0 to 100.0
#
# === Returns
# * `enrollment`: The updated Enrollment object
# * `errors`: Array of error messages
#
# === Example
# mutation {
#   updateProgressPercentEnrollment(id: 1, progressPercent: 80.0) {
#     enrollment { id progressPercent }
#     errors
#   }
# }
#
# @!endgroup

module Mutations
  module Enrollment
    class UpdateProgressPercentEnrollment < Mutations::Base::BaseMutation
      description "Update the progress percentage of an enrollment"

      argument :id, ID, required: true
      argument :progress_percent, Float, required: true

      field :enrollment, Types::Enrollment::EnrollmentType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, progress_percent:)
        enrollment = ::Enrollment.find_by(id: id)
        raise GraphQL::ExecutionError, "Not authorized" unless ability.can?(:update, enrollment)

        enrollment.progress_percent = progress_percent
        if progress_percent == 100.0
          enrollment.state = :completed
          enrollment.completed_at ||= Time.current
        end

        if enrollment.save
          { enrollment: enrollment, errors: [] }
        else
          { enrollment: nil, errors: enrollment.errors.full_messages }
        end
      end
    end
  end
end
