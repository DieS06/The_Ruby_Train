# frozen_string_literal: true

# == CourseType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for Course content units.
#
# Implements ContentUnitInterface.
#
# @example Query all courses
# {
#   courses {
#     id
#     title
#   }
# }
#
# @see Interfaces::ContentUnitInterface
#
# @!endgroup
#
module Types
  module ContentUnit
    class CourseType < Types::BaseObject
      implements Types::Interfaces::ContentUnitInterface
    end
  end
end
