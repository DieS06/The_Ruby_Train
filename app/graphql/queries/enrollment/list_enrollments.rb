# frozen_string_literal: true

# == ListEnrollments
#
# @!group 02-GraphQL / Queries / Enrollment
#
# === Example
# {
#   listEnrollments {
#     id
#     state
#     enrolledAt
#     user { email }
#     contentUnit { title }
#   }
# }
#
# @!endgroup
#

module Queries
  module Enrollment
    class ListEnrollments < Queries::BaseQuery
      description "List all enrollments for current user"

      type [ Types::Enrollment::EnrollmentType ], null: false

      def resolve
        user = context[:current_user]
        raise GraphQL::ExecutionError, "Authentication required" unless user

        ::Enrollment.where(user_id: user.id).includes(:user, :content_unit)
      end
    end
  end
end
