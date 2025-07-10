# frozen_string_literal: true

# == Content Unit
#
# @!group 01-Models / Content
#
# Content Unit is a model that represents a unit of content in a course,
# such as a course, module, segment, or lesson.
#
# === Attributes
# @!attribute [rw] type
#   @return [String] Type of content unit, used for Single Table Inheritance (STI).
# @!attribute [rw] parent_id
#   @return [Integer] ID of the parent content unit.
# @!attribute [rw] title
#   @return [String] Title of the content unit.
# @!attribute [rw] slug
#   @return [String] Unique identifier for the content unit.
# @!attribute [rw] state
#   @return [String] Enum: draft, published, archived, deleted
# @!attribute [rw] description
#   @return [Text] Description of the content unit.
#
# === Callbacks
# * `children` → Hierarchy representantion for content units.
# * `parent` → Reference to the parent ContentUnit.
#
# === Enums
# * `type`: STI inheritance (Course, Module, Segment, Lesson)
# * `state`: [:draft, :published, :archived, :deleted]
#
# @example Find a content unit by ID
# ContentUnit.find(1).children
#
# @example Find all content units with a specific slug
# ContentUnit.find_by(slug: "my-course-slug")
#
# @example Find all content units created by a specific user
# ContentUnit.where(created_by: 1)
#
# @example Returns all records where the type is Course
# ContentUnit.where(type: "Course") || Course.all
#
# @example Find all published lessons
# ContentUnit.where(type: "Lesson", state: "published")
#
# @!endgroup
#

class ContentUnit < ApplicationRecord
  include StateContent

  belongs_to :parent, class_name: "ContentUnit", optional: true
  has_many :children, class_name: "ContentUnit", foreign_key: "parent_id", dependent: :destroy
  has_many :content_topics, dependent: :destroy
  has_many :topics, through: :content_topics

  validates :type, presence: true
  validates :title, presence: true, length: { minimum: 10, maximum: 50 }
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10, maximum: 250 }
  validates :position, presence: true
  validates :lock_expire_at, allow_blank: true
  validates :created_by, presence: true

  scope :ordered, -> { order(position: :asc) }

  def to_param
    slug
  end

  def children
    ContentUnit.where(parent_id: id)
  end

  def available_for?(user)
    lock_expire_at.nil? || lock_expire_at > Time.current
  end
end

# == Schema Information
#
# === Table name: content_units
#
#  id              :bigint           not null, primary key
#  type            :string           not null
#  parent_id       :bigint           not null
#  title           :string           not null
#  slug            :string           not null
#  state           :integer          not null, default: 0
#  description     :text             not null
#  position        :integer          not null
#  lock_expire_at  :datetime         not null
#  created_by      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# === Indexes
#  index_content_units_on_slug  (slug) UNIQUE
#
# === Foreign Keys
# content_units_parent_id_fkey  (parent_id => content_units.id)
#
