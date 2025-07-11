# frozen_string_literal: true

# == MyProfile
#
# @!group 03-GraphQL / Queries / Profile
#
# === Example
#   {
#     myProfile {
#       id
#       bio
#       user { email }
#     }
#   }

module Queries
  module User
    class MyProfile < Queries::BaseQuery
      description "Returns the current user's profile"
      type Types::User::ProfileType, null: true

      def resolve
        context[:current_user].profile
      end
    end
  end
end
