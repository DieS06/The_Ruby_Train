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
      field :content, String, null: true
      field :video_url, String, null: true
      field :image_url, String, null: true

      def video_url
        object.video.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.video, only_path: true) : nil
      end

      def image_url
        object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) : nil
      end

      def children
        resolve_content_unit_children(object)
      end
    end
  end
end
