# frozen_string_literal: true

# == Progress
#
# Tracks a user's progress through a given ContentUnit, including state and score.
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
#
# === Associations
# * Belongs to a User
# * Belongs to a ContentUnit
#
# === Scopes
# * .completed — all progresses that have a completion timestamp
# * .in_progress — all progresses currently in progress
# * .failed — all progresses marked as failed
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
