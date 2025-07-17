# frozen_string_literal: true

# == DeleteGroup Mutation
#
# @!group 02-GraphQL / Mutations / Groups
#
# Archives an existing Group by setting its state to `"archived"`.
#
# === Authorization Rules
# * `super_admin` and `admin` can archive any group.
# * `academy` can archive only `"academic_group"` that they created.
# * `mentor` can archive only `"mentor_group"` where they are assigned.
#
# === Example
#   mutation {
#     deleteGroup(input: { id: 3 }) {
#       group {
#         id
#         state
#       }
#       errors
#     }
#   }
#
# === Arguments
# @!attribute id
#   @return [ID] ID of the group to archive.
#
# === Returns
# @return [Types::Group::GroupType] The archived group or error messages.
#
# @!endgroup
#

module Mutations
  module Group
    class DeleteGroup < Mutations::Base::BaseMutation
      description "Soft deletes (archives) a group"

      argument :id, ID, required: true

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(id:)
        group = ::Group.find_by(id:)
        return { group: nil, errors: [ "Group not found" ] } unless group

        authorize!(:update, group)
        current_user = context[:current_user]

        if current_user.has_role?(:mentor) && group.group_type != "mentor_group"
          return { group: nil, errors: [ "Mentors can only archive mentor groups." ] }
        end

        if current_user.has_role?(:academy)
          unless group.group_type == "academic_group" && group.created_by == current_user.id
            return { group: nil, errors: [ "Academy users can only archive their own academic groups." ] }
          end
        end

        if group.update(state: "archived")
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
