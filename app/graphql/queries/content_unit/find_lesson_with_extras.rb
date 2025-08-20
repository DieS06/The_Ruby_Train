# frozen_string_literal: true

# == find_lesson_with_extras
#
# @!group 02-GraphQL / Queries / ContentUnit
#
# Retrieves a single LessonUnit with extra fields like richBody, nextSlug, and previousSlug.
#
# === Arguments
# * `slug` [String, required] — Slug of the lesson.
#
# === Returns
# A LessonUnitType object with all base and extended fields.
#
# === Example (GraphQL)
# ```graphql
# query {
#   findLessonWithExtras(slug: "literals") {
#     id
#     title
#     slug
#     richBodyHtml
#     nextSlug
#     previousSlug
#     videoUrl
#     imageUrl
#   }
# }
# ```
#
# @!endgroup
#

module Queries
  module ContentUnit
    class FindLessonWithExtras < ::Queries::BaseQuery
      type Types::ContentUnit::LessonUnitType, null: true
      argument :slug, String, required: true

      def resolve(slug:)
        ::ContentUnit::LessonUnit.find_by(slug:)
      end
    end
  end
end
