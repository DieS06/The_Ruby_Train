# == CreateGroup Mutation
#
# @!group 02-GraphQL / Mutations / Groups
#
# Creates a new Group with required and optional attributes.
#
# === Authorization Rules
# * `super_admin` and `admin` can create any group without restrictions.
# * `mentor` can create only one group of type `"mentor_group"`.
# * `academy` can create up to two groups of type `"academic_group"`.
#
# === Example
#   mutation {
#     createGroup(input: {
#       name: "Bootcamp Ruby",
#       description: "Test group",
#       groupType: "mentor_group",
#       mentorId: 5,
#       academicId: 3,
#       state: "draft"
#     }) {
#       group {
#         id
#         name
#         slug
#         state
#       }
#       errors
#     }
#   }
#
# === Arguments
# @!attribute name
#   @return [String] The name of the group (required).
#
# @!attribute description
#   @return [String] Optional description of the group.
#
# @!attribute group_type
#   @return [String] The type of group: `"mentor_group"` or `"academic_group"` (required).
#
# @!attribute mentor_id
#   @return [Integer] Optional mentor ID associated with the group.
#
# @!attribute academic_id
#   @return [Integer] Optional academic ID associated with the group.
#
# @!attribute state
#   @return [String] Initial state of the group (e.g., `"draft"`).
#
# === Returns
# @return [Types::Group::GroupType] The created group or a list of validation errors.
#
# @!endgroup
#

module Mutations
  module Group
    class CreateGroup < Base::BaseMutation
      description "Create a new Group"

      argument :name, String, required: true
      argument :description, String, required: false
      argument :group_type, String, required: true
      argument :mentor_id, Integer, required: false
      argument :academic_id, Integer, required: false
      argument :state, String, required: true

      field :group, Types::Group::GroupType, null: true
      field :errors, [ String ], null: false

      def resolve(**args)
        authorize!(:create, Group)
        current_user = context[:current_user]

        if current_user.has_role?(:mentor)
          unless args[:group_type] == "mentor_group"
            return { group: nil, errors: [ "Mentors can only create 'mentor_group' type." ] }
          end

          count = Group.where(created_by: current_user.id, group_type: "mentor_group").count
          if count >= 1
            return { group: nil, errors: [ "Mentors can only create one group." ] }
          end
        end

        if current_user.has_role?(:academy)
          unless args[:group_type] == "academic_group"
            return { group: nil, errors: [ "Academy users can only create 'academic_group' type." ] }
          end

          count = Group.where(created_by: current_user.id, group_type: "academic_group").count
          if count >= 2
            return { group: nil, errors: [ "Academy group limit reached (max 2)." ] }
          end
        end

        group = ::Group.new(args)

        if group.save
          { group:, errors: [] }
        else
          { group: nil, errors: group.errors.full_messages }
        end
      end
    end
  end
end
