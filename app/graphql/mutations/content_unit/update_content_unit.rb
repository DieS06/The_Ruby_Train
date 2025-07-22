# frozen_string_literal: true

# == UpdateContentUnit
#
# @!group 02-GraphQL / Mutations / ContentUnit
#
# Updates attributes of a specific content unit by ID.
#
# === Arguments
# * `input` [Inputs::ContentUnit::UpdateContentUnitInput, required] — Attributes to update.
#
# === Returns
# * `content_unit` — The updated content unit node.
# * `errors` — Array of validation or system errors.
#
# === Example (GraphQL)
# ```graphql
# mutation {
#   updateContentUnit(input: {
#     id: 15,
#     title: "Updated Title"
#   }) {
#     contentUnit {
#       id
#       title
#     }
#     errors
#   }
# }
# ```
#
# @!endgroup


module Mutations
  module ContentUnit
    class UpdateContentUnit < ::Mutations::Base::BaseMutation
      description "Updates a content unit by ID"

      argument :input, Inputs::ContentUnit::UpdateContentUnitInput, required: true

      field :content_unit, Types::Interfaces::ContentUnitInterface, null: true

      def resolve(input:)
        unit = ::ContentUnit.find_by(id: input.id)
        return { content_unit: nil, errors: [ "Content unit not found" ] } unless unit

        if unit.update(input.to_h.except(:id).compact)
          { content_unit: unit, errors: [] }
        else
          { content_unit: nil, errors: unit.errors.full_messages }
        end
      end
    end
  end
end
