# frozen_string_literal: true

# == ContentTopicType
#
# @!group 02-GraphQL / Types / Topic
#
# GraphQL type for linking Topics to ContentUnits with metadata.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier for the content-topic relation.
# @!attribute [r] content_unit_id
#   @return [ID] ID of the associated content unit.
# @!attribute [r] topic_id
#   @return [ID] ID of the associated topic.
# @!attribute [r] relevance
#   @return [Integer] Relevance score (1–5) of the topic within the content unit.
# @!attribute [r] state
#   @return [String] State of the relation (draft, published, archived).
# @!attribute [r] topic
#   @return [Types::TopicType] Full topic object linked.
# @!attribute [r] created_at
#   @return [GraphQL::Types::ISO8601DateTime] Creation timestamp.
# @!attribute [r] updated_at
#   @return [GraphQL::Types::ISO8601DateTime] Last update timestamp.
#
# @example Query content topics
#   {
#     listContentTopics {
#       id
#       topic {
#         name
#       }
#     }
#   }
#
# @!endgroup
#

module Types
  module Topic
    class ContentTopicType < Types::BaseObject
      field :id, ID, null: false
      field :content_unit_id, ID, null: false
      field :topic_id, ID, null: false

      field :relevance, Integer, null: false
      field :state, String, null: false
      field :topic, Types::Topic::TopicType, null: false
      field :content_unit, Types::Interfaces::ContentUnitInterface, null: false

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
