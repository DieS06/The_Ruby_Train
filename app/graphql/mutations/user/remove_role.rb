# frozen_string_literal: true

# == RemoveRole
#
# @!group 03-GraphQL / Mutations / User
#
# Mutation to remove a role from a user.
#
# === Example
#   mutation {
#     removeRole(userId: 2, roleName: "mentor") {
#       user {
#         id
#         email
#         roleNames
#       }
#       errors
#     }
#   }
#
# === Arguments
# @!attribute user_id
#   @return [ID] ID of the user to remove role from
# @!attribute role_name
#   @return [String] Role to remove
#
# === Returns
# @return [Types::User::UserType] The user with updated roles or errors
#

module Mutations
  module User
    class RemoveRole < Mutations::Base::BaseMutation
      description "Removes a role from a user"

      argument :user_id, ID, required: true
      argument :role_name, String, required: true

      field :user, Types::User::UserType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, role_name:)
        current_user = context[:current_user]
        user = ::User.find_by(id: user_id)

        return { user: nil, errors: [ "User not found" ] } unless user

        unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
          raise GraphQL::ExecutionError, "Unauthorized"
        end

        if user.has_role?(role_name)
          user.remove_role(role_name)
        end

        { user: user, errors: [] }
      rescue => e
        Rails.logger.error("Error removing role: #{e.message}")
        { user: nil, errors: [ "An error occurred while removing role." ] }
      end
    end
  end
end
