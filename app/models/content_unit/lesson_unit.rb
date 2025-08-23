# frozen_string_literal: true

# == LessonUnit
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

class ContentUnit::LessonUnit < ContentUnit
  include CustomStiName
  has_rich_text :rich_body
  has_one_attached :video
  has_one_attached :image

  def next_slug
    siblings.where("position > ?", position).order(:position).first&.slug
  end

  def previous_slug
    siblings.where("position < ?", position).order(position: :desc).first&.slug
  end
end
