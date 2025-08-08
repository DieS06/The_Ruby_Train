# frozen_string_literal: true

# == LessonType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for Lesson content units.
#
# Implements ContentUnitInterface.
#
# @see Interfaces::ContentUnitInterface
#
# @!endgroup
#
module Types
  module ContentUnit
    class LessonUnitType < Types::BaseObject
      implements Types::Interfaces::ContentUnitInterface
      include Helpers::HasChildren

      field :rich_body_html, String, null: true
      field :video_url, String, null: true
      field :image_url, String, null: true
      field :next_slug, String, null: true
      field :previous_slug, String, null: true
      field :quizzes, [ Types::Evaluation::QuizType ], null: true,
      description: "Quiz associated with this segment."

      def video_url
        object.video.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.video, only_path: true) : nil
      end

      def image_url
        object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) : nil
      end

      def rich_body_html
        object.rich_body_html.to_s
      end

      def next_slug
        object.next_slug
      end

      def previous_slug
        object.previous_slug
      end

      def children
        resolve_content_unit_children(object)
      end

      def quizzes
        object.evaluations.quizzes
      end
    end
  end
end
