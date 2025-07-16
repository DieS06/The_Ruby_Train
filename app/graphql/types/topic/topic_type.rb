# frozen_string_literal: true

# == TopicType
#
# @!group 02-GraphQL / Types
#
# GraphQL type definition for the Topic model, exposing relevant fields.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier for the topic.
# @!attribute [r] name
#   @return [String] Name of the topic.
# @!attribute [r] description
#   @return [String] Optional description for the topic.
# @!attribute [r] created_at
#   @return [GraphQL::Types::ISO8601DateTime] Timestamp of creation.
# @!attribute [r] updated_at
#   @return [GraphQL::Types::ISO8601DateTime] Timestamp of last update.
#
# @example GraphQL query
#   {
#     topics {
#       id
#       name
#       description
#     }
#   }
#
# @!endgroup
#

module Types
  module Topic
    class TopicType < Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :description, String, null: true
      field :position, Integer, null: false
      field :parent_id, Integer, null: true
      field :state, String, null: false, description: "State of the topic (draft, published, archived, deleted)."

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
