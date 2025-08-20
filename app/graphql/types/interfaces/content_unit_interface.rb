# frozen_string_literal: true

# == ContentUnitInterface
#
# @!group 02-GraphQL / Interfaces
#
# GraphQL interface implemented by all ContentUnit types:
# Course, Module, Segment and Lesson.
#
# This interface defines shared fields for all content unit nodes.
#
# === Usage
# It is used in the resolve_type method of GraphQL to dynamically determine
# the type of a content unit.
#
# @example Accessing common fields
# {
#   contentUnits {
#     id
#     title
#     slug
#   }
# }
#
# @see Types::CourseType
# @see Types::ModuleType
# @see Types::SegmentType
# @see Types::LessonType
#
# @!endgroup
#

module Types
  module Interfaces
    module ContentUnitInterface
      include Types::BaseInterface
      description "Interface for all content unit types (Course, Module, Segment, Lesson)"

      field :id, ID, null: false
      field :type, String, null: false
      field :title, String, null: false
      field :slug, String, null: false
      field :state, String, null: false
      field :description, String, null: false
      field :position, Integer, null: false
      field :lock_expire_at, GraphQL::Types::ISO8601DateTime, null: true
      field :created_by, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :parent_id, ID, null: true, description: "ID of the parent content unit"

      field :children, [ Types::ContentUnit::ContentUnitUnion ], null: false

      definition_methods do
        def resolve_type(obj, _ctx)
          case obj.type
          when "Course" then Types::ContentUnit::CourseUnitType
          when "Module" then Types::ContentUnit::ModuleUnitType
          when "Segment" then Types::ContentUnit::SegmentUnitType
          when "Lesson" then Types::ContentUnit::LessonUnitType
          else
            raise GraphQL::ExecutionError, "Unknown ContentUnit type: #{obj.type}"
          end
        end
      end

      def children
        object.children.respond_to?(:ordered) ? object.children.ordered : object.children
      end
    end
  end
end
