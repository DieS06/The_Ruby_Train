# frozen_string_literal: true

# == ContentUnitChildrenResolver
#
# @!group 02-GraphQL / Resolvers
#
# Central resolver for fetching children of any ContentUnit ordered by position.
#
# @example
# include GraphQL::ContentUnitChildrenResolver
# def children
#   resolve_content_unit_children(object)
# end
#
# @!endgroup
#

module Helpers
  module HasChildren
    def resolve_content_unit_children(unit)
      unit.children.ordered
    end
  end
end
