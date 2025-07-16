# frozen_string_literal: true

# == FindProfile
#
# @!group 03-GraphQL / Queries / Profile
#
# === Example
#   {
#     findProfile(id: 1) {
#       id
#       bio
#       githubUrl
#       user { email }
#     }
#   }

module Queries
  module User
    class FindProfile < Queries::BaseQuery
      description "Find a profile by ID"

      argument :id, ID, required: true
      type Types::User::ProfileType, null: true

      def resolve(id:)
        profile = ::Profile.find_by(id: id)
        raise GraphQL::ExecutionError, "Not authorized" unless ability.can?(:read, profile)
        profile
      end
    end
  end
end
