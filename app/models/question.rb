# frozen_string_literal: true

# == Question
#
# @!group 01-Models / Evaluations
#
# Represents a single question in an evaluation (quiz or exam).
#
# === Attributes
# @!attribute [rw] evaluation_id
#   @return [Integer] Associated evaluation
# @!attribute [rw] evaluation_section_id
#   @return [Integer] Optional section if part of an exam
# @!attribute [rw] topic_id
#   @return [Integer] Optional topic reference, for search and organization.
# @!attribute [rw] statement
#   @return [Text] Question statement
# @!attribute [rw] question_type
#   @return [Integer] Enum: single_choice, multiple_choiexce, true_false, text_input
# @!attribute [rw] position
#   @return [Integer] Display order
# @!attribute [rw] explanation
#   @return [Text] Optional explanation shown after answering
# @!attribute [rw] points
#   @return [Integer] Score weight of the question
#

class Question < ApplicationRecord
  belongs_to :evaluation
  belongs_to :evaluation_section, optional: true
  belongs_to :topic, optional: true

  has_many :answer_options, dependent: :destroy


  enum :question_type, {
    single_choice: 0,
    multiple_choice: 1,
    true_false: 2,
    text_input: 3
  }

  validates :statement, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :explanation, length: { minimum: 20, maximum: 1000 }, allow_blank: true
  validates :question_type, :position, :points, presence: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }

  scope :by_topic, ->(topic_id) {
    where(topic_id: topic_id)
  }

  def choice_based?
    %w[single_choice multiple_choice true_false].include?(question_type)
  end

  private

  def only_one_correct_option
    return unless single_choice? && answer_options.where(correct: true).size > 1

    errors.add(:answer_options, "Only one correct option allowed for single choice questions")
  end
end
