# frozen_string_literal: true

# == ListProfiles
#
# @!group 03-GraphQL / Queries / Profile
#
# === Example
#   {
#     listProfiles(page: 1, perPage: 10) {
#       id
#       location
#       user { email }
#     }
#   }

module Queries
  module User
    class ListProfiles < Queries::BaseQuery
      description "List all profiles"

      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 20

      type [ Types::User::ProfileType ], null: false

      def resolve(page:, per_page:)
        raise GraphQL::ExecutionError, "Unauthorized" unless ability.can?(:read, ::Profile)
        ::Profile.page(page).per(per_page)
      end
    end
  end
end
