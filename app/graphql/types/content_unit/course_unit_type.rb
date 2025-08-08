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
    class CourseUnitType < Types::BaseObject
      implements Interfaces::ContentUnitInterface
      include Helpers::HasChildren

      field :final_exams, [ Types::Evaluation::ExamType ], null: true,
      description: "Final exams associated with this course."

      def final_exams
        object.evaluations.exams
      end
    end
  end
end
