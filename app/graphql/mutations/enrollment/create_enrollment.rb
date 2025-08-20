# frozen_string_literal: true

# == CreateEnrollment
#
# @!group 02-GraphQL / Enrollment
#
# Enrolls the current user in a course-type ContentUnit.
#
# === Arguments
# * `content_unit_id`: ID of the course to enroll in.
#
# === Returns
# * `enrollment`: The created Enrollment object
# * `errors`: Array of error messages
#
# === Example
# mutation {
#   createEnrollment(contentUnitId: 5) {
#     enrollment { id state }
#     errors
#   }
# }
#
# @!endgroup
#

module Mutations
  module Enrollment
    class CreateEnrollment < Mutations::Base::BaseMutation
      description "Enroll a user in a course (ContentUnit::CourseUnit)"

      argument :content_unit_id, ID, required: true

      field :enrollment, Types::Enrollment::EnrollmentType, null: true
      field :content_unit, Types::Interfaces::ContentUnitInterface, null: false
      field :errors, [ String ], null: false

      def resolve(content_unit_id:)
        user = context[:current_user]
        raise GraphQL::ExecutionError, "Authentication required." unless user

        content_unit = ::ContentUnit.find_by(id: content_unit_id)
        raise GraphQL::ExecutionError, "Course not found." unless content_unit&.type == "course"

        enrollment = ::Enrollment.new(user: user, content_unit: content_unit)
        raise GraphQL::ExecutionError, "Not authorized" unless ability.can?(:create, enrollment)

        if enrollment.save
          { enrollment: enrollment, errors: [] }
        else
          { enrollment: nil, errors: enrollment.errors.full_messages }
        end
      end
    end
  end
end
