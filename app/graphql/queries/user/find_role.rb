# frozen_string_literal: true

# == FindRole
#
# @!group 03-GraphQL / Queries / Role
#
# Query to retrieve a specific role by ID.
#
# === Example
#   {
#     findRole(id: 1) {
#       id
#       name
#       resourceType
#     }
#   }
#
# === Arguments
# @!attribute id
#   @return [ID] The ID of the role to retrieve
#
# === Returns
# @return [Types::User::RoleType] The role object if found and authorized
#

module Queries
  module User
    class FindRole < Queries::BaseQuery
      description "Find a role by ID"

      argument :id, ID, required: true
      type Types::User::RoleType, null: true

      def resolve(id:)
        role = ::Role.find_by(id: id)
        raise GraphQL::ExecutionError, "Role not found" unless role
        raise GraphQL::ExecutionError, "Unauthorized" unless context[:current_user].can?(:read, role)

        role
      end
    end
  end
end
