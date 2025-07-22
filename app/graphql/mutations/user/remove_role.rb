# == RemoveRole
#
# @!group 02-GraphQL / Mutations / User
#
# Removes a role from a user, optionally scoped to a specific resource.
# This mutation does not update structural associations such as `group.mentor_id`.
# Use `RemoveMentorFromGroup` for that purpose.
#
# === Authorization Rules
# * Only users with roles `super_admin`, `admin`, or `academy` can remove roles.
# * Only `super_admin` can remove the `admin` role.
# * `academy` users can only remove `mentor` roles scoped to a group they own.
#
# === Behavior
# * Removes a global or scoped role using Rolify.
# * If scoped, both `resource_type` and `resource_id` are required.
# * Does not remove role from associated model fields like `Group#mentor_id`.
#
# === Example
# mutation {
#   removeRole(userId: 2, roleName: "mentor", resourceType: "Group", resourceId: 3) {
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
#   @return [ID] ID of the user whose role will be removed.
#
# @!attribute role_name
#   @return [String] Role to be removed. Must be one of: "super_admin", "admin", "academy", "mentor", "student".
#
# @!attribute resource_type
#   @return [String] Optional resource type (e.g., "Group") if the role is scoped.
#
# @!attribute resource_id
#   @return [ID] Optional resource ID to which the role is scoped.
#
# === Returns
# @return [Types::User::UserType] User with roles updated or errors if any.
#
# @!endgroup
#

module Mutations
  module User
    class RemoveRole < Mutations::Base::BaseMutation
      description "Removes a role from a user"

      argument :user_id, ID, required: true
      argument :role_name, String, required: true
      argument :resource_type, String, required: false
      argument :resource_id, ID, required: false

      field :user, Types::User::UserType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, role_name:, resource_type: nil, resource_id: nil)
        authorize!(:remove_role, User)
        user = ::User.find_by(id: user_id)
        return { user: nil, errors: [ "User not found." ] } unless user

        unless ALLOWED_ROLES.include?(role_name)
          return { user: nil, errors: [ "Invalid role name." ] }
        end

        if resource_type.present? && resource_id.present?
          remove_with_resource(user, role_name, resource_type, resource_id)
        else
          remove_without_resource(user, role_name)
        end
      rescue => e
        Rails.logger.error("Error removing role: #{e.class} - #{e.message}")
        { user: nil, errors: [ "#{e.class} - #{e.message}" ] }
      end

      private

      def remove_with_resource(user, role_name, resource_type, resource_id)
        resource = resource_type.safe_constantize&.find_by(id: resource_id)
        return { user: nil, errors: [ "Resource not found." ] } unless resource

        if current_user.has_role?(:academy) && role_name == "mentor"
          unless current_user.groups.include?(resource)
            return { user: nil, errors: [ "You are not authorized to remove mentors from this group." ] }
          end
        elsif current_user.has_role?(:academy)
          return { user: nil, errors: [ "Academy users can only remove 'mentor' roles within their groups." ] }
        end

        user.remove_role(role_name.to_sym, resource)
        { user:, errors: [] }
      end

      def remove_without_resource(user, role_name)
        if role_name == "admin" && !current_user.has_role?(:super_admin)
          return { user: nil, errors: [ "Only super admins can remove admin roles." ] }
        end

        if %w[mentor academy].include?(role_name)
          unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
            return { user: nil, errors: [ "Only admins or super admins can remove this role without a resource." ] }
          end
        end

        user.remove_role(role_name.to_sym)
        { user:, errors: [] }
      end
    end
  end
end
