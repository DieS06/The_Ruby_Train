# frozen_string_literal: true

# == AssignRole
#
# @!group 02-GraphQL / Mutations / User
#
# Mutation to assign a role to a user, optionally scoped to a resource.
#
# === Description
# Assigns a role to a user, either globally or scoped to a specific resource like a Group.
# This mutation does not assign ownership or structural associations to models such as Group.
# For example, assigning a mentor to a Group (updating the `mentor_id`) must be handled by a
# separate mutation such as `AssignMentorToGroup`.
#
# === Authorization Rules
# * Only `super_admin`, `admin`, or `academy` can assign roles.
# * Only `super_admin` can assign the `admin` role.
# * `mentor` and `academy` roles without resource can be assigned by `admin` or `super_admin`.
# * `mentor` role scoped to a Group can be assigned by `academy`, `admin`, or `super_admin`.
# * `academy` role scoped to a Group can be assigned by `admin` or `super_admin`.
#
# === Role Contexts
# * `mentor` can optionally be scoped to a group (`resource_type: "Group"`).
# * `academy` can optionally be scoped to a group (`resource_type: "Group"`).
# * This mutation only assigns the role using Rolify. It does not modify fields like `group.mentor_id`.
#
# === Example
# mutation {
#   assignRole(
#     userId: 2,
#     roleName: "mentor",
#     resourceType: "Group",
#     resourceId: 3
#   ) {
#     user {
#       id
#       email
#       roleNames
#     }
#     errors
#   }
# }
#
# === Arguments
# @!attribute user_id
#   @return [ID] ID of the user to assign the role to.
#
# @!attribute role_name
#   @return [String] Name of the role to assign (e.g., "mentor", "admin").
#   Must be one of the following: "super_admin", "admin", "academy", "mentor", "student".
#
# @!attribute resource_type
#   @return [String] Optional resource type to scope the role (e.g., "Group").
#
# @!attribute resource_id
#   @return [ID] Optional resource ID to scope the role.
#
# === Returns
# @return [Types::User::UserType] The updated user with roles, or a list of validation errors.
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
        authorize!(:assign_role, User)
        user = ::User.find_by(id: user_id)
        return { user: nil, errors: [ "User not found." ] } unless user

        unless ALLOWED_ROLES.include?(role_name)
          return { user: nil, errors: [ "Invalid role name." ] }
        end

        if resource_type.present? && resource_id.present?
          result = assign_with_resource(user, role_name, resource_type, resource_id)
        else
          result = assign_without_resource(user, role_name)
        end

        result
      rescue => e
        Rails.logger.error("Error assigning role: #{e.class} - #{e.message}")
        { user: nil, errors: [ "#{e.class} - #{e.message}" ] }
      end

      private

      def assign_with_resource(user, role_name, resource_type, resource_id)
        resource = resource_type.safe_constantize&.find_by(id: resource_id)
        return { user: nil, errors: ["Resource not found."] } unless resource

        if role_name == "mentor"
          unless current_user.has_role?(:academy) || current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
            return { user: nil, errors: ["Only academy, admin or super_admin can assign mentors to a group."] }
          end
        elsif role_name == "academy"
          unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
            return { user: nil, errors: ["Only admins or super_admins can assign academy to a group."] }
          end
        end

        unless user.has_role?(role_name.to_sym, resource)
          user.add_role(role_name.to_sym, resource)
        end

        { user:, errors: [] }
      end

      def assign_without_resource(user, role_name)
        if role_name == "admin"  && !current_user.has_role?(:super_admin)
          return { user: nil, errors: [ "Only super admins can assign administrator roles." ] }
        end

        if %w[mentor academy].include?(role_name)
          unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
            return { user: nil, errors: [ "Only admins or super admins can assign '#{role_name}' role without resource." ] }
          end
        end

        user.add_role(role_name.to_sym)
        { user:, errors: [] }
      end
    end
  end
end
