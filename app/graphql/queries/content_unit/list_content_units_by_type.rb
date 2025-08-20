# frozen_string_literal: true

# == list_content_units
#
# @!group 02-GraphQL / Queries / ContentUnit
#
# Lists all content units optionally filtered by parent ID.
#
# === Arguments
# * `parent_id` [ID, optional] — Filters by parent content unit.
#
# === Returns
# Array of:
# * CourseUnitType
# * ModuleUnitType
# * SegmentUnitType
# * LessonUnitType
#
# === Example (GraphQL)
# ```graphql
# {
#   listContentUnits(parentId: 2) {
#     ... on ModuleUnitType {
#       id title slug
#     }
#   }
# }
# ```
#
# === Example (Insomnia)
# - Method: POST
# - URL: http://localhost:3000/graphql
# - Body (JSON):
# ```json
# {
#   "query": "query { listContentUnits(parentId: 2) { ... on ModuleUnitType { id title slug } } }"
# }
# ```
#
# @!endgroup
#
module Queries
  module ContentUnit
    class ListContentUnitsByType < ::Queries::BaseQuery
      type [ Types::ContentUnit::ContentUnitUnion ], null: false
      description "List content units optionally filtered by parent"

      argument :parent_id, ID, required: false

      def resolve(parent_id: nil)
        scope = ::ContentUnit.all
        scope = scope.where(parent_id: parent_id) if parent_id.present?
        scope.ordered
      end
    end
  end
end
