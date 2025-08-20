# frozen_string_literal: true

# == Find_content_unit_with_hierarchy
#
# @!group 02-GraphQL / Queries / ContentUnit
#
# Recursively retrieves the hierarchy of content units starting from a specific node,
# either ascending (to parent units) or descending (to children).
#
# === Arguments
# * `type` [String, required] — Type of content unit ("Course", "Module", etc.)
# * `id` [ID, optional] — Unique ID of the content unit
# * `slug` [String, optional] — Slug of the content unit (alternative to ID)
# * `direction` [HierarchyDirectionEnum, required] — Direction of hierarchy traversal:
#
# === Returns
# One content unit node including its full hierarchy (nested recursively).
#
# === Example (GraphQL)
# ```graphql
# {
#   resolveContentUnitHierarchy(type: "Course", slug: "ruby-from-zero", direction: "DESC") {
#     ... on CourseUnitType {
#       id title slug
#       children {
#         ... on ModuleUnitType {
#           id title slug
#         }
#       }
#     }
#   }
# }
# ```
#
# === Example (Insomnia)
# ```graphql
# query {
#   resolveContentUnitHierarchy(type: "Course", slug: "ruby-from-zero", direction: "DESC") {
#     id
#     title
#     slug
#     ... on CourseUnitType {
#       children {
#         id title slug
#       }
#     }
#   }
# }
# ```
#
# @!endgroup
#

module Queries
  module ContentUnit
    class FindContentUnitWithHierarchy < ::Queries::BaseQuery
      type Types::Interfaces::ContentUnitInterface, null: true
      description "Resolves a content unit and its full hierarchy (up or down)"

      argument :type, String, required: true
      argument :id, ID, required: false
      argument :slug, String, required: false
      argument :direction, Types::Enums::HierarchyDirectionEnum, required: true

      def resolve(type:, id: nil, slug: nil, direction: nil)
        klass = "ContentUnit::#{type}Unit".safe_constantize
        raise GraphQL::ExecutionError, "Invalid type '#{type}'" unless klass && klass < ::ContentUnit

        node = id ? klass.find_by(id: id) : klass.find_by(slug: slug)
        raise GraphQL::ExecutionError, "Content unit not found" unless node

        case direction.upcase
        when "ASC"
          resolve_asc(node)
        when "DESC"
          resolve_desc(node)
        else
          raise GraphQL::ExecutionError, "Invalid direction. Use ASC or DESC."
        end
      end

      private

      def resolve_asc(node)
        return node unless node.parent

        parent = node.parent
        override_children(parent, [ node ])
        resolve_asc(parent)
      end

      def resolve_desc(node)
        node.children.load
        node.children = node.children.map { |child| resolve_desc(child) }
        override_children(node, node.children)
        node
      end

      def override_children(node, children_array)
        ids = children_array.map(&:id)

        relation = ::ContentUnit.where(id: ids).order(:position)
        node.define_singleton_method(:children) { relation }
      end
    end
  end
end
