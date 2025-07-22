# frozen_string_literal: true

# == ModuleType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for Module content units.
#
# Implements ContentUnitInterface.
#
# @see Interfaces::ContentUnitInterface
#
# @!endgroup
#
module Types
  module ContentUnit
    class ModuleUnitType < Types::BaseObject
      implements Types::Interfaces::ContentUnitInterface
      include Helpers::HasChildren
      def children
        resolve_content_unit_children(object)
      end
    end
  end
end
