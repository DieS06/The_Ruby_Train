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

      field :exams, [ Types::Evaluation::ExamType ], null: true,
      description: "Exams associated with this module."

      def children
        resolve_content_unit_children(object)
      end

      def exams
        object.evaluations.exams
      end
    end
  end
end
