# frozen_string_literal: true

# == FindUser
#
# @!group 03-GraphQL / Queries / User
#
# Query to retrieve a single user by ID.
#
# === Example
#   {
#     findUser(id: 1) {
#       id
#       email
#       roleNames
#       profile { bio }
#     }
#   }
#
# === Arguments
# @!attribute id
#   @return [ID] The ID of the user to retrieve
#
# === Returns
# @return [Types::User::UserType] The user object if found, otherwise null
#

module Queries
  module User
    class FindUser < Queries::BaseQuery
      description "Find a user by ID"
      argument :id, ID, required: true

      type Types::User::UserType, null: true

      def resolve(id:)
        ::User.find_by(id: id)
      end
    end
  end
end
