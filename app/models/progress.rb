# frozen_string_literal: true

# == Progress
#
# @!group 01-Models / Progress
#
# Tracks a user's progress through a given ContentUnit, including state, score, and percentage.
#
# === Attributes
# @!attribute [rw] user_id
#   @return [Integer] Reference to the user
# @!attribute [rw] content_unit_id
#   @return [Integer] Reference to the associated content unit
# @!attribute [rw] completed_at
#   @return [DateTime, nil] Timestamp when the unit was completed
# @!attribute [rw] score
#   @return [Integer, nil] Score obtained by the user
# @!attribute [rw] state
#   @return [Integer] Enum: not_started: 0, in_progress: 1, passed: 2, failed: 3
# @!attribute [rw] progress_percentage
#   @return [Integer] Percentage of completion (0–100)
# @!attribute [rw] last_accessed_at
#   @return [DateTime, nil] Last time the user interacted with the unit
# @!attribute [rw] created_at
#   @return [DateTime] Record creation time
# @!attribute [rw] updated_at
#   @return [DateTime] Record update time
#
# === Associations
# @!attribute [r] user
#   @return [User] The associated user
# @!attribute [r] content_unit
#   @return [ContentUnit] The associated content unit
#
# === Scopes
# @!method self.completed
#   @return [ActiveRecord::Relation] Progress records with a non-null completed_at
# @!method self.in_progress
#   @return [ActiveRecord::Relation] Progress records currently in progress
# @!method self.failed
#   @return [ActiveRecord::Relation] Progress records marked as failed
#
# === Instance Methods
# @!method complete(score = nil)
#   Marks the progress as completed, sets the score and timestamp.
#   @param score [Integer, nil] Optional score value
#   @return [Boolean] Whether the update succeeded
#
# @!method fail
#   Marks the progress as failed.
#   @return [Boolean] Whether the update succeeded
#
# @!method in_progress?
#   @return [Boolean] Whether the progress is currently in progress
#
# @!method completed?
#   @return [Boolean] Whether the progress has a completion timestamp
#
# @!endgroup
#

class Progress < ApplicationRecord
  include PublicActivity::Model
  tracked owner: :user

  belongs_to :user
  belongs_to :content_unit

  enum :state, {
    not_started: 0,
    in_progress: 1,
    passed: 2,
    failed: 3
  }

  validates :user, presence: true
  validates :content_unit, presence: true
  validates :state, presence: true, inclusion: { in: Progress.states.keys }
  validates :score, numericality: { only_integer: true, allow_nil: true }
  validates :progress_percentage, numericality: { only_integer: true, in: 0..100 }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(state: :in_progress) }
  scope :failed, -> { where(state: :failed) }

  def complete(score = nil)
    update(completed_at: Time.current, score: score, state: :passed)
  end

  def fail
    update(state: :failed)
  end

  def in_progress?
    state == "in_progress"
  end

  def completed?
    completed_at.present?
  end
end
