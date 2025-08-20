# frozen_string_literal: true

# == UpdateGroup Mutation
#
# @!group 02-GraphQL / Mutations / Groups
#
# Updates the attributes of an existing Group.
#
# === Authorization Rules
# * Only `admin`, `super_admin`, or `academy` users assigned to the resource can update it.
# * `mentor` can only update groups of type `"mentor_group"`.
# * `academy` can only update groups of type `"academic_group"`.
#
# === Example
#   mutation {
#     updateGroup(input: {
#       id: 3,
#       name: "New name",
#       description: "Updated description",
#       state: "archived"
#     }) {
#       group {
#         id
#         name
#         description
#         state
#       }
#       errors
#     }
#   }
#
# === Arguments
# @!attribute id
#   @return [ID] ID of the group to be updated (required).
#
# @!attribute name
#   @return [String] Optional new name of the group.
#
# @!attribute description
#   @return [String] Optional new description of the group.
#
# @!attribute group_type
#   @return [String] Optional new group type.
#
# @!attribute state
#   @return [String] Optional new state of the group.
#
# === Returns
# @return [Types::Group::GroupType] The updated group or validation errors.
#
# @!endgroup
#

module Mutations
  module Group
    class UpdateGroup < Mutations::Base::BaseMutation
      description "Update an existing Group"

      argument :id, ID, required: true
      argument :name, String, required: false
      argument :description, String, required: false
      argument :group_type, String, required: false
      argument :state, String, required: false

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, **attrs)
        group = ::Group.find_by(id:)
        return { group: nil, errors: [ "Group not found" ] } unless group

        authorize!(:update, group)
        current_user = context[:current_user]

        if current_user.has_role?(:mentor)
          unless group.group_type == "mentor_group"
            return { group: nil, errors: [ "Mentors can only update 'mentor_group' type." ] }
          end
        end

        if current_user.has_role?(:academy)
          unless group.group_type == "academic_group"
            return { group: nil, errors: [ "Academy users can only update 'academic_group' type." ] }
          end
        end

        if group.update(attrs)
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
