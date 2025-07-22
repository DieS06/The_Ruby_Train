# frozen_string_literal: true

# == ContentUnitUnion
#
# @!group 02-GraphQL / Unions
#
# GraphQL union type that unifies all content unit object types
# (CourseUnitType, ModuleUnitType, SegmentUnitType, LessonUnitType).
#
# Used in GraphQL mutations and queries when the result can be
# any of the subclasses of ContentUnit.
#
# === Implements
# * Types::ContentUnit::CourseUnitType
# * Types::ContentUnit::ModuleUnitType
# * Types::ContentUnit::SegmentUnitType
# * Types::ContentUnit::LessonUnitType
#
# === Example usage
# ```graphql
# mutation {
#   createContentUnit(...) {
#     contentUnit {
#       ... on CourseUnitType { id title }
#       ... on LessonUnitType { id videoUrl }
#     }
#   }
# }
# ```
#
# @!endgroup
#

module Types
  module ContentUnit
    class ContentUnitUnion < Types::BaseUnion
      description "Union of all content unit types"

      possible_types Types::ContentUnit::CourseUnitType,
                    Types::ContentUnit::ModuleUnitType,
                    Types::ContentUnit::SegmentUnitType,
                    Types::ContentUnit::LessonUnitType

      def self.resolve_type(object, _context)
        case object.type
        when "Course" then Types::ContentUnit::CourseUnitType
        when "Module" then Types::ContentUnit::ModuleUnitType
        when "Segment" then Types::ContentUnit::SegmentUnitType
        when "Lesson" then Types::ContentUnit::LessonUnitType
        else
          raise GraphQL::ExecutionError, "Unknown type"
        end
      end
    end
  end
end
