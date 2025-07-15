# frozen_string_literal: true

# == Topics
#
# @!group 01-Models / Content
#
# Topic is a model that represents a topic in the content management system.
#
# === Attributes
# @!attribute [rw] name
#   @return [String] Name of the topic, must be unique.
# @!attribute [rw] description
#   @return [Text] Brief description of the topic.
# @!attribute [rw] position
#   @return [Integer] Position of the topic in the hierarchy, used for ordering.
# @!attribute [rw] parent_id
#   @return [Integer] ID of the parent topic, if any.
# @!attribute [rw] state
#   @return [String] Enum: draft, published, archived, deleted.
#
# === Associations
# * has_many :content_topics
# * has_many :content_units, through: :content_topics
# * belongs_to :parent (self-referential)
# * has_many :children (self-referential)
#
# === Scopes
# * .roots → top-level topics with no parent
# * .ordered_children → children ordered by position
#
# === Methods
# * ordered_descendants → recursive tree traversal for visual dis
#
# @example
# Topic.roots.each do |root|
#     puts root.name
#     root.ordered_descendants.each { |child| puts "-- #{child[:topic].name}" }
#  end
#
# @!endgroup
#

class Topic < ApplicationRecord
  include StateContent

  has_many :content_topics, dependent: :destroy
  has_many :content_units, through: :content_topics

  belongs_to :parent, class_name: "Topic", optional: true
  has_many :children, class_name: "Topic", foreign_key: "parent_id", dependent: :destroy

  validates :name, presence: true
  validates :description, length: { minimum: 10, maximum: 250 }, allow_blank: true
  validates :position, presence: true
  validates :parent_id, presence: true, allow_blank: true

  scope :roots, -> { where(parent_id: nil).order(:position) }
  scope :ordered_children, -> { order(:position) }

  def ordered_descendants(depth = 0)
    children.ordered_children.map do |child|
      { depth: depth + 1, topic: child, children: child.ordered_descendants(depth + 1) }
    end
  end
end
