# frozen_string_literal: true

# == DeleteContentUnit
#
# @!group 02-GraphQL / Mutations / ContentUnit
#
# Deletes a specific content unit by ID.
#
# === Arguments
# * `id` [ID, required] — ID of the content unit to delete.
#
# === Returns
# * `success` — Boolean indicating success.
# * `errors` — Array of error messages.
#
# === Example (GraphQL)
# ```graphql
# mutation {
#   deleteContentUnit(id: 15) {
#     success
#     errors
#   }
# }
# ```
#
# @!endgroup
#

module Mutations
  module ContentUnit
    class DeleteContentUnit < ::Mutations::Base::BaseMutation
      description "Deletes a content unit by ID"

      argument :id, ID, required: true
      field :success, Boolean, null: false
      field :errors, [ String ], null: false

      def resolve(id:)
        unit = ::ContentUnit.find_by(id: id)
        return { success: false, errors: [ "Content unit not found" ] } unless unit

        if unit.destroy
          { success: true, errors: [] }
        else
          { success: false, errors: unit.errors.full_messages }
        end
      end
    end
  end
end
