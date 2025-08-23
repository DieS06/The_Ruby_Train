# frozen_string_literal: true

# == find_lesson_nav
#
# Returns prev/current/next items for the carousel, plus quiz_id for the segment.
#
# args:
#  - slug: String! (lesson slug)
#
#
module Queries
  module ContentUnit
    class FindLessonNav < ::Queries::BaseQuery
      type ::Types::ContentUnit::LessonNavPayloadType, null: false
      description "Returns nav items (prev/current/next) for a lesson and the segment quiz id"

      argument :slug, String, required: true

      def resolve(slug:)
        lesson = ::ContentUnit::LessonUnit.find_by!(slug: slug)
        segment = lesson.parent # must be a SegmentUnit
        raise GraphQL::ExecutionError, "Parent segment not found" unless segment&.type == "Segment"

        lessons = segment.children.where(type: "Lesson").order(:position).to_a
        idx = lessons.index { |l| l.id == lesson.id } || 0

        prev = idx.positive? ? lessons[idx - 1] : nil
        cur  = lessons[idx]
        nxt  = (idx < lessons.size - 1) ? lessons[idx + 1] : nil

        items = [ prev, cur, nxt ].compact.map { |l|
          { id: l.id, title: l.title, slug: l.slug }
        }

        quiz_id = segment.evaluations.quizzes.first&.id

        {
          items: items,
          current_index: idx,
          quiz_id: quiz_id
        }
      end
    end
  end
end
