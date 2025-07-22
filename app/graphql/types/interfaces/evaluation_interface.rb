# frozen_string_literal: true

# == EvaluationInterface
#
# @!group 02-GraphQL / Interfaces
#
# Interface for all evaluation types (Quiz, Exam).
# Shared fields: id, title, state, type, description, timeLimit, contentUnit
#
# @!endgroup
#

module Types
  module Interfaces
    module EvaluationInterface
      include Types::BaseInterface
      description "Shared interface for all evaluations (quiz, exam)"

      field :id, ID, null: false
      field :title, String, null: false
      field :description, String, null: true
      field :time_limit, Integer, null: true
      field :state, String, null: false
      field :content_unit_id, Integer, null: false
      field :created_by, Integer, null: false
      field :total_points, Integer, null: false
      field :graded, Boolean, null: false, method: :graded?

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :content_unit, Types::ContentUnit::ContentUnitUnion, null: false

      definition_methods do
        def resolve_type(obj, _ctx)
          case obj.type
          when "Quiz" then Types::Evaluation::QuizType
          when "Exam" then Types::Evaluation::ExamType
          else raise "Unknown Evaluation type: #{obj.type}"
          end
        end
      end
    end
  end
end
