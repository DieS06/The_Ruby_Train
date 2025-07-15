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

      field :content_unit, Interfaces::ContentUnitInterface, null: true
      field :errors, [ String ], null: false

      def resolve(input:)
        klass = ::ContentUnit::TYPES.include?(input[:type]) ? "ContentUnit::#{input[:type]}".constantize : nil
        return { content_unit: nil, errors: [ "Invalid type" ] } unless klass

        unit = klass.new(
          title: input[:title],
          slug: input[:slug],
          description: input[:description],
          parent_id: input[:parent_id],
          created_by: context[:current_user]&.id || 1 # fallback for testing
        )

        if unit.save
          { content_unit: unit, errors: [] }
        else
          { content_unit: nil, errors: unit.errors.full_messages }
        end
      end
    end
  end
end
