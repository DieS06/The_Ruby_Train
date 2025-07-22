# frozen_string_literal: true

# == list_content_units
#
# @!group 02-GraphQL / Queries / ContentUnit
#
# Lists all content units using the shared interface. No need to use GraphQL fragments.
#
# === Returns
# Array of objects implementing ContentUnitInterface:
# * CourseUnitType
# * ModuleUnitType
# * SegmentUnitType
# * LessonUnitType
#
# === Example (GraphQL)
# ```graphql
# {
#   listContentUnits {
#     id title type slug
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
#   "query": "query { listContentUnits { id title type slug } }"
# }
# ```
#
# @!endgroup
#
module Queries
  module ContentUnit
    class ListContentUnits < ::Queries::BaseQuery
      type [ Types::Interfaces::ContentUnitInterface ], null: false
      description "List all content units using shared interface"

      def resolve
        ::ContentUnit.ordered
      end
    end
  end
end
