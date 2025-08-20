# frozen_string_literal: true

# == ListGroups Query
#
# @!group 02-GraphQL / Queries / Groups
#
# Retrieves a list of groups.
#
# === Authorization Rules
# * `super_admin` and `admin` → can list all groups.
# * `academy` → can list their created groups.
# * `mentor` → can list groups where they have roles.
#
# === Example
#   query {
#     listGroups {
#       id
#       name
#       groupType
#       state
#     }
#   }
#
# === Returns
# @return [Types::Group::GroupType]
#
# @!endgroup
#

module Queries
  module Group
    class ListGroups < ::Queries::BaseQuery
      type [ Types::Group::GroupType ], null: false

      def resolve
        current_user = context[:current_user]
        authorize!(:read, ::Group)

        if current_user.has_role?(:super_admin) || current_user.has_role?(:admin)
          ::Group.all
        elsif current_user.has_role?(:academy)
          ::Group.where(created_by: current_user.id)
        elsif current_user.has_role?(:mentor)
          current_user.assigned_groups
        else
          []
        end
      end
    end
  end
end
