# frozen_string_literal: true

# == AddMemberToGroup
#
# @!group 02-GraphQL / Mutations / Groups
#
# Adds an existing user to a group by creating a GroupMembership.
# This does not create a new user or send an invitation — for that, use `inviteUserToPlatform`.
#
# === Authorization Rules
# * Only users with role `admin`, `super_admin`, or `academy` (owner of the group) can add members.
#
# === Behavior
# * Creates a GroupMembership between the user and the group.
# * Fails if the user is already a member.
# * Registers `invited_by` with `current_user.id`.
# * Sets `state` as `joined`.
#
# === Example
# mutation {
#   addMemberToGroup(input: {
#     userId: 22,
#     groupId: 5,
#     roleInGroup: "member"
#   }) {
#     membership {
#       id
#       user {
#         email
#       }
#       group {
#         name
#       }
#       roleInGroup
#       state
#     }
#     errors
#   }
# }
#
# === Arguments
# @!attribute user_id
#   @return [ID] ID of the user to be added.
#
# @!attribute group_id
#   @return [ID] ID of the group.
#
# @!attribute role_in_group
#   @return [String] Optional role inside the group (default: "member").
#
# === Returns
# @return [Types::Group::GroupMembershipType] The created membership or validation errors.
#
# @!endgroup
#

module Mutations
  module Group
    class AddMemberToGroup < Mutations::Base::BaseMutation
      description "Adds an existing user to a group."

      argument :user_id, ID, required: true
      argument :group_id, ID, required: true
      argument :role_in_group, String, required: false

      field :membership, Types::Group::GroupMembershipType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, group_id:, role_in_group:)
        group = ::Group.find_by(id: group_id)
        return { membership: nil, errors: [ "Group not found." ] } unless group

        user = ::User.find_by(id: user_id)
        return { membership: nil, errors: [ "User not found." ] } unless user

        authorize!(:update, group)

        existing = ::GroupMembership.find_by(user_id:, group_id:)
        return { membership: nil, errors: [ "User is already a member of this group." ] } if existing

        membership = ::GroupMembership.new(
          user_id:,
          group_id:,
          role_in_group:,
          invited_by: current_user.id,
          state: "invited"
        )
        membership.invited_token = SecureRandom.hex(16) if membership.state == "invited"

        if membership.save
          { membership:, errors: [] }
        else
          { membership: nil, errors: membership.errors.full_messages }
        end
      end
    end
  end
end
