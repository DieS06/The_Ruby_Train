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
    class SegmentType < Types::BaseObject
      implements Types::Interfaces::ContentUnitInterface
    end
  end
end
