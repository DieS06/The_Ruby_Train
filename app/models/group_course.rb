# frozen_string_literal: true

# == GroupCourse
#
# @!group 01-Models / Groups
#
# Represents the assignment of a course (ContentUnit) to a specific Group.
#
# === Attributes
# @!attribute [rw] group_id
#   @return [Integer] Foreign key to the Group
# @!attribute [rw] content_unit_id
#   @return [Integer] Foreign key to the assigned course (must be a ContentUnit of type Course)
# @!attribute [rw] assigned_at
#   @return [DateTime] Timestamp when the course was assigned
# @!attribute [rw] state
#   @return [Integer] Enum: draft, active, archived
#
# === Associations
# * belongs_to :group
# * belongs_to :content_unit (only of type Course)
#
# === Validations
# * Uniqueness on [group_id, content_unit_id]
# * ContentUnit must be a Course
#
# @!endgroup
#

class GroupCourse < ApplicationRecord
  include StateGroup

  belongs_to :group
  belongs_to :content_unit

  validates :group_id, uniqueness: { scope: :content_unit_id }
  validates :assigned_at, presence: true
  validates :state, presence: true
  validate  :must_be_course_type

  before_validation :set_assigned_at, on: :create

  private

  def set_assigned_at
    self.assigned_at ||= Time.current
  end

  def must_be_course_type
    if content_unit && content_unit.type != "Course"
      errors.add(:content_unit_id, "must be of type Course")
    end
  end
end
