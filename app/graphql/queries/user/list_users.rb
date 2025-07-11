# frozen_string_literal: true

# == Queries::User::FindAll
#
# @!group 03-GraphQL / Queries / User
#
# Returns a paginated list of all users. Admins only.
#
# === Example
# {
#   users(page: 1, perPage: 10) {
#     id
#     email
#     roles { name }
#   }
# }
#
# @!endgroup
#
module Queries
  module User
    class ListUsers < Queries::BaseQuery
      description "Returns a list of all users, with optional pagination. Admins only."

      type [ Types::User::UserType ], null: false

      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 10

      def resolve(page:, per_page:)
        unless current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
          raise GraphQL::ExecutionError, "You are not authorized to access the list of users."
        end

        ::User.page(page).per(per_page)
      rescue => e
        Rails.logger.error("Error fetching users: #{e.message}")
        raise GraphQL::ExecutionError, "Failed to fetch users"
      end
    end
  end
end
