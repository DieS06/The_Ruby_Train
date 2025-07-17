# frozen_string_literal: true

# == Group
#
# @!group 01-Models / Groups
#
# Represents a learning group or cohort. Can be used to assign mentors,
# enroll users, and track progress through content units.
#
# === Attributes
# @!attribute [rw] name
#   @return [String] Visible name of the group, not necessarily unique.
# @!attribute [rw] description
#   @return [Text] Optional description of the group's purpose.
# @!attribute [rw] group_type
#   @return [Integer] Enum: mentor_group, academic_group, other
# @!attribute [rw] mentor_id
#   @return [Integer] Optional User ID assigned as mentor
# @!attribute [rw] academic_id
#   @return [Integer] Optional User ID assigned as academic advisor
# @!attribute [rw] state
#   @return [Integer] Enum: open, active, closed, archived
# @!attribute [rw] slug
#   @return [String] Unique system-generated identifier for internal use or URLs
#
# === Callbacks
# * `resourcify` → includes CanCanCan resource management
# * `before_validation :generate_unique_slug` → generates unique `slug`
#
# === Associations
# * belongs_to :mentor (User) || * belongs_to :academic (User)
# * has_many :group_memberships
# * has_many :users, through: :group_memberships
# * has_many :group_courses
# * has_many :content_units, through: :group_courses
#
# === Scopes & Methods
# * `to_param` returns `slug`
#
# @!endgroup
#

class Group < ApplicationRecord
  include StateGroup
  resourcify

  before_validation :generate_unique_slug, on: :create

  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :group_courses, dependent: :destroy
  has_many :content_units, through: :group_courses

  belongs_to :mentor, class_name: "User", optional: true
  belongs_to :academic, class_name: "User", optional: true

  enum :group_type, {
    mentor_group: 0,
    academic_group: 1,
    other: 2
  }

  validates :name, presence: true
  validates :description, length: { maximum: 300 }, allow_blank: true
  validates :group_type, presence: true
  validates :state, presence: true

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :expired_deletions, -> { where("deleted_at <= ?", 31.days.ago) }

  private

  def to_param
    slug
  end

  def generate_unique_slug
    base = name.parameterize.presence || "group"
    loop do
      candidate = "#{base}-#{SecureRandom.hex(3)}"
      unless Group.exists?(slug: candidate)
        self.slug = candidate
        break
      end
    end
  end
end
