# frozen_string_literal: true

# == AssignAcademicToGroup
#
# @!group 02-GraphQL / Mutations / Groups
#
# Assigns an existing academic to a specific group by updating the `academic_id` field.
# This mutation does not assign the `academy` role to the user. That must be handled
# separately using `AssignRole` if necessary.
#
# === Authorization Rules
# * Only users with role `admin`, `super_admin`, or `academy` (owner of the group) can assign an academic.
#
# === Behavior
# * Updates the `academic_id` field of the given group with the specified user.
# * Fails if the group or user does not exist.
# * Fails if the user does not have the `academy` role.
# * Fails if the group already has an academic assigned.
#
# === Example
# mutation {
#   assignAcademicToGroup(input: {
#     groupId: 5,
#     academicId: 15
#   }) {
#     group {
#       id
#       name
#       academic {
#         id
#         email
#       }
#     }
#     errors
#   }
# }
#
# === Arguments
# @!attribute group_id
#   @return [ID] ID of the group to which the academic will be assigned.
#
# @!attribute academic_id
#   @return [ID] ID of the user to assign as the group's academic. Must already have the `academy` role.
#
# === Returns
# @return [Types::Group::GroupType] The updated group with the assigned academic or a list of validation errors.
#
# @!endgroup

module Mutations
  module Group
    class AssignAcademicToGroup < Mutations::Base::BaseMutation
      description "Assign an academic to a group"

      argument :group_id, ID, required: true
      argument :academic_id, ID, required: true

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(group_id:, academic_id:)
        group = ::Group.find_by(id: group_id)
        return { group: nil, errors: [ "Group not found." ] } unless group

        authorize!(:update, group)
        return { group: nil, errors: [ "Group already has an academic assigned." ] } if group.academic_id.present?

        academic = ::User.find_by(id: academic_id)
        return { group: nil, errors: [ "Academic not found." ] } unless academic
        return { group: nil, errors: [ "User is not an academy." ] } unless academic.has_role?(:academy)

        group.academic_id = academic.id

        if group.save
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
