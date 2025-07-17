# frozen_string_literal: true

# == FindGroup
#
# @!group 02-GraphQL / Queries / Groups
#
# Returns a specific group by ID, if the user has access.
#
# === Authorization Rules
# * Requires `:read` permission on the target group.
#
# === Example
#   query {
#     findGroup(id: 3) {
#       id
#       name
#       groupType
#       state
#     }
#   }
#
# === Arguments
# @!attribute id
#   @return [ID] ID of the group to retrieve
#
# === Returns
# @return [Types::Group::GroupType, nil] The requested group or nil
#
# @!endgroup
#

module Queries
  module Group
    class FindGroup < ::Queries::BaseQuery
      description "Find a group by ID"

      type Types::Group::GroupType, null: true
      argument :id, ID, required: true

      def resolve(id:)
        group = ::Group.find_by(id:)
        authorize!(:read, group)
        group
      end
    end
  end
end
