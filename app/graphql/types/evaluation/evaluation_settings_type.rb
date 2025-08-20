# frozen_string_literal: true

# == EvaluationSettingType
#
# @!group 02-GraphQL / Types
#
# GraphQL type for evaluation settings (number of attempts, visibility, etc.)
#
# === Attributes
# @!attribute [r] id
#   @return [ID] Unique identifier for the settings record
# @!attribute [r] evaluation_id
#   @return [ID] Associated Evaluation ID
# @!attribute [r] attempts_allowed
#   @return [Integer] Max number of attempts allowed (nullable)
# @!attribute [r] shuffle_questions
#   @return [Boolean] Whether to shuffle questions
# @!attribute [r] show_results
#   @return [Boolean] Whether to show score after submission
# @!attribute [r] show_feedback
#   @return [Boolean] Whether to show explanations after submission
# @!attribute [r] created_at
#   @return [ISO8601DateTime]
# @!attribute [r] updated_at
#   @return [ISO8601DateTime]
#
# # === Relations
# @!attribute [r] evaluation
#   @return [EvaluationUnion]
#
# @example Querying settings
# query {
#   evaluation(id: 1) {
#     settings {
#       attemptsAllowed
#       shuffleQuestions
#     }
#   }
# }
#
# @see EvaluationSetting
#
# @!endgroup
#

module Types
  class EvaluationSettingType < Types::BaseObject
    description "Settings and configuration rules for an evaluation"

    field :id, ID, null: false
    field :evaluation_id, ID, null: false

    field :attempts_allowed, Integer, null: true, description: "Maximum number of attempts allowed"
    field :shuffle_questions, Boolean, null: false, description: "Whether questions should be shuffled"
    field :show_results, Boolean, null: false, description: "Whether to show results after submission"
    field :show_feedback, Boolean, null: false, description: "Whether to show feedback after submission"
    field :config, GraphQL::Types::JSON, null: true, description: "Additional configuration settings in JSON format"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :evaluation, Types::Evaluation::EvaluationUnion, null: false
  end
end
