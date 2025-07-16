# frozen_string_literal: true

# == CreateGroup Mutation
#
# @!group 02-GraphQL / Mutations / Groups
#
# Creates a new Group with required and optional attributes.
#
# @example GraphQL Mutation
#   mutation {
#     createGroup(input: {
#       name: "Bootcamp Ruby",
#       description: "Grupo de prueba",
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
        authorize! :create, ::Group

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
