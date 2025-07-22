# == AssignMentorToGroup
#
# @!group 02-GraphQL / Mutations / Groups
#
# Assigns an existing mentor to a specific group by updating the `mentor_id` field.
# This mutation does not assign the `mentor` role to the user. That must be handled
# separately using `AssignRole` if necessary.
#
# === Authorization Rules
# * Only users with role `admin`, `super_admin`, or `academy` (owner of the group) can assign a mentor.
#
# === Behavior
# * Updates the `mentor_id` field of the given group with the specified mentor.
# * Fails if the group or mentor does not exist.
# * Fails if the user does not have the `mentor` role.
# * Fails if the group already has a mentor assigned.
#
# === Example
# mutation {
#   assignMentorToGroup(input: {
#     groupId: 5,
#     mentorId: 12
#   }) {
#     group {
#       id
#       name
#       mentor {
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
#   @return [ID] ID of the group to which the mentor will be assigned.
#
# @!attribute mentor_id
#   @return [ID] ID of the user to assign as the group's mentor. Must already have the `mentor` role.
#
# === Returns
# @return [Types::Group::GroupType] The updated group with the assigned mentor or a list of validation errors.
#
# @!endgroup


module Mutations
  module Group
    class AssignMentorToGroup < Mutations::Base::BaseMutation
      description "Assign a mentor to a group"

      argument :group_id, ID, required: true
      argument :mentor_id, ID, required: true

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(group_id:, mentor_id:)
        group = ::Group.find_by(id: group_id)
        return { group: nil, errors: [ "Group not found" ] } unless group

        authorize!(:update, group)
        return { group: nil, errors: [ "Group already has a mentor assigned." ] } if group.mentor_id.present?

        mentor = ::User.find_by(id: mentor_id)
        return { group: nil, errors: [ "Mentor not found" ] } unless mentor
        return { group: nil, errors: [ "User is not a mentor" ] } unless mentor.has_role?(:mentor)

        group.mentor_id = mentor.id

        if group.save
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
