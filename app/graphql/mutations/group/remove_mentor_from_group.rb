# frozen_string_literal: true

# == RemoveMentorFromGroup
#
# @!group 02-GraphQL / Mutations / Groups
#
# Removes the assigned mentor from a specific group by setting `mentor_id` to `nil`.
# This mutation does not remove the `mentor` role from the user. That must be handled
# separately using `RemoveRole` if necessary.
#
# === Authorization Rules
# * Only users with roles `admin`, `super_admin`, or `academy` (owner of the group) can remove a mentor.
#
# === Behavior
# * Sets the `mentor_id` field of the given group to `nil`.
# * Fails if the group does not exist or does not have a mentor assigned.
# * Fails if the current user is not authorized to update the group.
#
# === Example
# mutation {
#   removeMentorFromGroup(input: {
#     groupId: 5
#   }) {
#     group {
#       id
#       name
#       mentorId
#     }
#     errors
#   }
# }
#
# === Arguments
# @!attribute group_id
#   @return [ID] ID of the group whose mentor will be removed.
#
# === Returns
# @return [Types::Group::GroupType] The updated group or a list of validation errors.
#
# @!endgroup
#

module Mutations
  module Group
    class RemoveMentorFromGroup < Mutations::Base::BaseMutation
      description "Remove the mentor from a group"

      argument :group_id, ID, required: true

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(group_id:)
        group = ::Group.find_by(id: group_id)
        return { group: nil, errors: [ "Group not found." ] } unless group

        authorize!(:update, group)

        return { group: nil, errors: [ "Group has no mentor assigned." ] } if group.mentor_id.nil?

        group.mentor_id = nil

        if group.save
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
