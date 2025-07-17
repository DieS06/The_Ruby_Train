# frozen_string_literal: true

# == AssignRole
#
# @!group 03-GraphQL / Mutations / User
#
#  Mutation to assign a role to a user, optionally scoped to a resource.
#
# === Example
#  mutation {
#     assignRole(userId: 2, roleName: "mentor", resourceType: "Group", resourceId: 3) {
#       user {
#         id
#         email
#         roleNames
#       }
#       errors
#     }
#   }
#
# === Authorization Rules
# * Only `super_admin`, `admin` and `academy` users can assign roles.
# * Only `super_admin` can assign the `admin` role.
# * An `academy` can assign `mentor` roles only if they are within the limit.
# * `mentor` and `academy` roles require a `resource_type` and `resource_id`.
#
# === Role Contexts
# * `mentor` is scoped to a specific group (`resource_type: "Group"`)
# * `academy` may also be scoped to a resource if needed
#
# === Arguments
# @!attribute user_id
#   @return [ID] ID of the user to assign the role to
#
# @!attribute role_name
#   @return [String] Name of the role to assign (e.g., "mentor", "admin")
#
# @!attribute resource_type
#   @return [String] Optional resource type for scoping (e.g., "Group")
#
# @!attribute resource_id
#   @return [ID] Optional resource ID for scoping the role
#
# === Returns
# @return [Types::User::UserType] Updated user with new role or error messages
#
# @!endgroup
#

module Mutations
  module User
    class AssignRole < Mutations::Base::BaseMutation
      description "Assigns a role to a user"

      argument :user_id, ID, required: true
      argument :role_name, String, required: true
      argument :resource_type, String, required: false
      argument :resource_id, ID, required: false

      field :user, Types::User::UserType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, role_name:, resource_type: nil, resource_id: nil)
        current_user = context[:current_user]
        user = ::User.find_by(id: user_id)

        return { user: nil, errors: [ "User not found." ] } unless user

        unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin) || current_user.has_role?(:academy)
          raise GraphQL::ExecutionError, "Unauthorized"
        end

        if %w[mentor academy].include?(role_name)
          return { user: nil, errors: [ "Missing resource information." ] } unless resource_type && resource_id

          begin
            resource_class = resource_type.constantize
            resource = resource_class.find(resource_id)
          rescue NameError, ActiveRecord::RecordNotFound
            return { user: nil, errors: [ "Resource not found." ] }
          end

          if current_user.has_role?(:academy) && role_name == "mentor"
            max_mentors = 2
            assigned = ::User.with_role(:mentor, resource).count
            return { user: nil, errors: [ "Mentor limit reached for this academy group." ] } if assigned >= max_mentors
          end

          user.add_role(role_name.to_sym, resource)
        else
          if role_name == "admin" && !current_user.has_role?(:super_admin)
            return { user: nil, errors: [ "Only super admins can assign administrator roles." ] }
          end

          user.add_role(role_name.to_sym)
        end

        { user: user, errors: [] }
      rescue => e
        Rails.logger.error("Error assigning role: #{e.class} - #{e.message}")
        { user: nil, errors: [ "#{e.class} - #{e.message}" ] }
      end
    end
  end
end
