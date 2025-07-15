# frozen_string_literal: true

# == Lesson
#
# @!group 01-Models / Content
#
# Represents a lesson inside a segment, the lowest unit in the hierarchy.
# Contains rich text, a video and an image attachment.
#
# === Examples
#   Lesson.create(title: "Using yield", parent: Segment.first)
#
# @see ContentUnit
#
# @!endgroup
#

class ContentUnit::Lesson < ContentUnit
  has_rich_text :content
  has_one_attached :video
  has_one_attached :image
end
