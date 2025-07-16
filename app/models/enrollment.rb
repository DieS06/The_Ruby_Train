# frozen_string_literal: true

# == Enrollment
#
# @!group 01-Models / Enrollment
#
# Represents a user enrollment into a specific course.
#
# === Attributes
# @!attribute [rw] user_id
#   @return [Integer] Reference to the enrolled user
# @!attribute [rw] content_unit_id
#   @return [Integer] Reference to the enrolled course (type: Course)
# @!attribute [rw] enrolled_at
#   @return [DateTime] Timestamp of enrollment
# @!attribute [rw] status
#   @return [Integer] Enum: pending, active, completed, withdrawn
# @!attribute [rw] progress_percent
#   @return [Decimal] Progress from 0.0 to 100.0
#
# === Associations
# * belongs_to :user
# * belongs_to :content_unit (type must be Course)
#
# === Validations
# * Uniqueness [user_id, content_unit_id]
# * status presence and inclusion
# * progress between 0 and 100
#
# @!endgroup
#

class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :content_unit
  before_save :set_completed_at

  enum :state, { active: 0, completed: 1 }

  validates :state, presence: true
  validates :progress_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :user_id, uniqueness: { scope: :content_unit_id }
  validate :must_be_course

  before_validation :set_enrolled_at, on: :create

  private

  def set_enrolled_at
    self.enrolled_at ||= Time.current
  end

  def must_be_course
    if content_unit && content_unit.type != "course"
      errors.add(:content_unit, "must be of type Course")
    end
  end

  def set_completed_at
    if state_changed? && completed?
      self.completed_at ||= Time.current
    end
  end
end
