# frozen_string_literal: true

# == ListRoles
#
# @!group 03-GraphQL / Queries / Role
#
# Query to list all roles, paginated.
#
# === Example
#   {
#     listRoles(page: 1, perPage: 20) {
#       id
#       name
#       resourceType
#     }
#   }
#
# === Arguments
# @!attribute page
#   @return [Integer] The page number (optional)
#
# @!attribute per_page
#   @return [Integer] Number of roles per page (optional)
#
# === Returns
# @return [Array<Types::User::RoleType>] A list of role objects
#
module Queries
  module User
    class ListRoles < Queries::BaseQuery
      description "List all roles with optional pagination"

      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 20

      type [ Types::User::RoleType ], null: false

      def resolve(page:, per_page:)
        unless context[:current_user]&.can?(:read, ::Role)
          raise GraphQL::ExecutionError, "Unauthorized"
        end

        ::Role.page(page).per(per_page)
      end
    end
  end
end
