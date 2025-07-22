# frozen_string_literal: true

# == CreateContentUnit
#
# @!group 02-GraphQL / Mutations
#
# Mutation to create any content unit (Course, Module, Segment, Lesson).
#
# @example
# mutation {
#   createContentUnit(input: {
#     type: "Course",
#     title: "Ruby Basics",
#     slug: "ruby-basics",
#     description: "Intro",
#     parentId: null
#   }) {
#     contentUnit {
#       id title slug type
#     }
#     errors
#   }
# }
#
# @!endgroup
#
module Mutations
  module ContentUnit
    class CreateContentUnit < Base::BaseMutation
      argument :type, String, required: true
      argument :title, String, required: true
      argument :slug, String, required: true
      argument :description, String, required: true
      argument :parent_id, ID, required: false

      field :content_unit, Types::ContentUnit::ContentUnitUnion, null: true
      field :errors, [ String ], null: false

      def resolve(type:, title:, slug:, description:, parent_id: nil)
        return { content_unit: nil, errors: [  "Invalid type" ] } unless ::ContentUnit::TYPES.include?(type)

        unit = ::ContentUnit.new(
          type: type,
          title: title,
          slug: slug,
          description: description,
          parent_id: parent_id,
          created_by: context[:current_user]&.id || 15
        )

        unit.assign_position if unit.position.blank?

        if unit.save
          { content_unit: unit, errors: [] }
        else
          { content_unit: nil, errors: unit.errors.full_messages }
        end
      end
    end
  end
end
