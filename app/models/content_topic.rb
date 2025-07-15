# frozen_string_literal: true

# == ContentTopic
#
# @!group 01-Models / Content
#
# ContentTopic links a Topic to a specific ContentUnit (course/module/lesson).
# It includes metadata like relevance and state.
#
# === Attributes
# @!attribute [rw] content_unit_id
#   @return [Integer] Reference to the associated content unit.
# @!attribute [rw] topic_id
#   @return [Integer] Reference to the associated topic.
# @!attribute [rw] relevance
#   @return [Integer] Importance level of the topic for this content (1–5).
# @!attribute [rw] state
#   @return [String] Enum: draft, published, archived
#
# === Associations
# * belongs_to :content_unit
# * belongs_to :topic
#
# === Validations
# * Uniqueness: one topic per content unit
#
# @example Find all content topics for a specific content unit
# ContentTopic.where(content_unit_id: 1).includes(:topic)
#
# @!endgroup
#

class ContentTopic < ApplicationRecord
  include StateContent

  belongs_to :content_unit
  belongs_to :topic

  validates :relevance, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :state, presence: true
  validates :topic_id, uniqueness: { scope: :content_unit_id }
  validate :topic_name_unique_per_course

  private

  def topic_name_unique_per_course
    if ContentTopic.joins(:topic)
        .where(content_unit_id: content_unit_id)
        .where("topics.name = ?", topic.name)
        .where.not(id: id)
        .exists?
      errors.add(:topic_id, "Has already been used for this content unit")
    end
  end
end
