# frozen_string_literal: true

# == GroupMembershipType
#
# @!group 02-GraphQL / Types / Group
#
# GraphQL type for the GroupMembership model. Represents a user's participation in a group,
# including their role, invitation status, and membership state.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier for the membership record.
# @!attribute [r] group_id
#   @return [Integer] ID of the associated group.
# @!attribute [r] user_id
#   @return [Integer] ID of the associated user.
# @!attribute [r] joined_at
#   @return [GraphQL::Types::ISO8601DateTime] Timestamp when user joined the group.
# @!attribute [r] role_in_group
#   @return [String] Enum: member, assistant, mentor, coordinator.
# @!attribute [r] invited_by
#   @return [Integer] ID of the user who sent the invitation.
# @!attribute [r] invited_token
#   @return [String] Optional token for invitation-based joins.
# @!attribute [r] state
#   @return [String] Enum: draft, invited, joined, archived.
# @!attribute [r] created_at
#   @return [GraphQL::Types::ISO8601DateTime] When the group-course relation was created.
# @!attribute [r] updated_at
#   @return [GraphQL::Types::ISO8601DateTime] When the group-course relation was last updated.
#
# === Associations
# * group: Group object.
# * user: User object.
# * inviter: User who invited this member.
#
# @example
#   {
#     groupMemberships {
#       id
#       groupId
#       userId
#       roleInGroup
#       state
#       user {
#         id
#         email
#       }
#     }
#   }
#
# @!endgroup
#

module Types
  module Group
    class GroupMembershipType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :user_id, Integer, null: false
      field :joined_at, GraphQL::Types::ISO8601DateTime, null: true
      field :role_in_group, String, null: false
      field :invited_by, Integer, null: true
      field :invited_token, String, null: true
      field :state, String, null: false

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :group, Types::Group::GroupType, null: false
      field :user, Types::User::UserType, null: false
      field :inviter, Types::User::UserType, null: true
    end
  end
end
