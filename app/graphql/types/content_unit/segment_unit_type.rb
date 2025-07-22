# frozen_string_literal: true

# == SegmentType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for Segment content units.
#
# Implements ContentUnitInterface.
#
# @see Interfaces::ContentUnitInterface
#
# @!endgroup
#

module Types
  module ContentUnit
    class SegmentUnitType < Types::BaseObject
      implements Types::Interfaces::ContentUnitInterface
      include Helpers::HasChildren
      def children
        resolve_content_unit_children(object)
      end
    end
  end
end
