# frozen_string_literal: true

# == find_content_unit
#
# @!group 02-GraphQL / Queries / ContentUnit
#
# Finds a specific content unit by ID using ContentUnitInterface.
#
# === Arguments
# * `id` [ID, required] — The ID of the content unit to retrieve.
#
# === Returns
# One of:
# * CourseUnitType
# * ModuleUnitType
# * SegmentUnitType
# * LessonUnitType
#
# === Example (GraphQL)
# ```graphql
# {
#   findContentUnit(id: 5) {
#     id title type slug
#   }
# }
# ```
#
# === Example (Insomnia)
# ```graphql
# query {
#   findContentUnit(id: 5) {
#     id
#     title
#     type
#     slug
#   }
# }
# ```
#
# @!endgroup
#
module Queries
  module ContentUnit
    class FindContentUnit < ::Queries::BaseQuery
      type Types::Interfaces::ContentUnitInterface, null: true
      description "Find a single content unit by ID"

      argument :id, ID, required: true

      def resolve(id:)
        ::ContentUnit.find_by(id: id)
      end
    end
  end
end
