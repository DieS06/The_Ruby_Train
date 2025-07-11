# frozen_string_literal: true

# == AssignRole
#
# @!group 03-GraphQL / Mutations / User
#
# Mutation to assign a role to a user.
#
# === Example
#   mutation {
#     assignRole(userId: 2, roleName: "mentor") {
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
#   @return [ID] ID of the user to assign role to
#
# @!attribute role_name
#   @return [String] The role to assign
#
# === Returns
# @return [Types::User::UserType] Updated user with new role or errors
#

module Mutations
  module User
    class AssignRole < Mutations::Base::BaseMutation
      description "Assigns a role to a user"

      argument :user_id, ID, required: true
      argument :role_name, String, required: true

      field :user, Types::User::UserType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, role_name:)
        current_user = context[:current_user]
        user = ::User.find_by(id: user_id)

        return { user: nil, errors: [ "User not found." ] } unless user

        unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin) || current_user.has_role?(:academy)
          raise GraphQL::ExecutionError, "Unauthorized"
        end

        if current_user.has_role?(:academy) && role_name == "mentor"
          max_mentors = 2
          assigned_mentors = ::User.with_role(:mentor)
                .joins(:roles)
                .where(roles: { resource_id: current_user.id, resource_type: "User" })
                .count

          if assigned_mentors >= max_mentors
            return { user: nil, errors: [ "Mentor limit reached for this academy." ] }
          end

          user.add_role(role_name, current_user)
        else
          user.add_role(role_name)
        end

        { user: user, errors: [] }
      rescue => e
        Rails.logger.error("Error assigning role: #{e.message}")
        { user: nil, errors: [ "An error occurred while assigning role." ] }
      end
    end
  end
end
