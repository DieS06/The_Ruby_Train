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

    definition_methods do
      def resolve_type(object, _ctx)
        case object.type
        when "Course" then Types::CourseType
        when "Module" then Types::ModuleType
        when "Segment" then Types::SegmentType
        when "Lesson" then Types::LessonType
        else raise "Unknown ContentUnit type: #{object.type}"
        end
      end
    end
  end
end
