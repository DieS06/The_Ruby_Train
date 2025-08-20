# frozen_string_literal: true

# == GroupCourseType
#
# @!group 02-GraphQL / Types / Group
#
# GraphQL type for the GroupCourse model. Represents the assignment of a course to a group,
# including its state and timestamp.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier of the group-course relation.
# @!attribute [r] group_id
#   @return [Integer] ID of the associated group.
# @!attribute [r] content_unit_id
#   @return [Integer] ID of the associated content unit (must be a Course).
# @!attribute [r] assigned_at
#   @return [GraphQL::Types::ISO8601DateTime] When the course was assigned to the group.
# @!attribute [r] state
#   @return [String] Enum: active, archived.
# @!attribute [r] created_at
#   @return [GraphQL::Types::ISO8601DateTime] When the group-course relation was created.
# @!attribute [r] updated_at
#   @return [GraphQL::Types::ISO8601DateTime] When the group-course relation was last updated.
#
# === Associations
# * group: Group object
# * content_unit: ContentUnit object (must be type Course)
#
# @example
# {
#   groupCourses {
#     id
#     state
#     group {
#       id
#       name
#     }
#     contentUnit {
#       id
#       title
#     }
#   }
# }
#
# @!endgroup
#

module Types
  module Group
    class GroupCourseType < Types::BaseObject
      field :id, ID, null: false
      field :group_id, Integer, null: false
      field :content_unit_id, Integer, null: false
      field :assigned_at, GraphQL::Types::ISO8601DateTime, null: false
      field :state, String, null: false

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :group, Types::Group::GroupType, null: false
      field :content_unit, Types::Content::ContentUnitType, null: false
    end
  end
end
