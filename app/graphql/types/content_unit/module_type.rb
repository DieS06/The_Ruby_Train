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
    class ModuleType < Types::BaseObject
      implements Interfaces::ContentUnitInterface
    end
  end
end
