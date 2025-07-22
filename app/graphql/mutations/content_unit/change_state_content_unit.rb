# frozen_string_literal: true

# == ChangeContentUnitState
#
# @!group 02-GraphQL / Mutations / ContentUnit
#
# Changes the state of a content unit by ID (e.g., draft → published).
#
# === Arguments
# * `input` [Inputs::ContentUnit::ChangeContentUnitStateInput, required]
#
# === Returns
# * `content_unit` — The updated content unit.
# * `errors` — List of validation or system errors.
#
# === Example (GraphQL)
# ```graphql
# mutation {
#   changeContentUnitState(input: {
#     id: 15,
#     state: "published"
#   }) {
#     contentUnit {
#       id
#       title
#       state
#     }
#     errors
#   }
# }
# ```
#
# @!endgroup
#
module Mutations
  module ContentUnit
    class ChangeStateContentUnit < ::Mutations::Base::BaseMutation
      description "Changes the state of a content unit"

      argument :input, Inputs::ContentUnit::ChangeStateContentUnitInput, required: true
      field :content_unit, Types::Interfaces::ContentUnitInterface, null: true
      field :errors, [ String ], null: false

      def resolve(input:)
        unit = ::ContentUnit.find_by(id: input.id)
        return { content_unit: nil, errors: [ "Content unit not found" ] } unless unit

        if unit.update(state: input.state)
          { content_unit: unit, errors: [] }
        else
          { content_unit: nil, errors: unit.errors.full_messages }
        end
      end
    end
  end
end
