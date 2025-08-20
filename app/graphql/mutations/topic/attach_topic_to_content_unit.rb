# frozen_string_literal: true

# == AttachTopicToContentUnit Mutation
#
# @!group 03-GraphQL / Mutations / ContentTopic
#
# Attaches an existing Topic to a ContentUnit, creating a ContentTopic relation.
#
# === Arguments
# @!attribute [r] topic_id
#   @return [ID] ID of the topic to attach.
# @!attribute [r] content_unit_id
#   @return [ID] ID of the content unit to attach to.
# @!attribute [r] relevance
#   @return [Integer] Relevance level (1–5) for this topic.
# @!attribute [r] state
#   @return [String] State of the relation (draft, published, archived).
#
# === Returns
# @!attribute [r] content_topic
#   @return [Types::ContentTopicType] The created relation between content and topic.
# @!attribute [r] errors
#   @return [Array<String>] Errors if creation failed.
#
# @example
#   mutation {
#     attachTopicToContentUnit(
#       topicId: 3,
#       contentUnitId: 12,
#       relevance: 2,
#       state: "draft"
#     ) {
#       contentTopic {
#         id
#         relevance
#         topic {
#           name
#         }
#       }
#       errors
#     }
#   }
#
# @!endgroup
#

module Mutations
  module Topic
    class AttachTopicToContentUnit < Base::BaseMutation
      argument :topic_id, ID, required: true
      argument :content_unit_id, ID, required: true
      argument :relevance, Integer, required: true
      argument :state, String, required: true

      field :content_topic, Types::Topic::ContentTopicType, null: true
      field :errors, [ String ], null: false

      def resolve(topic_id:, content_unit_id:, relevance:, state:)
        content_topic = ::ContentTopic.new(
          topic_id: topic_id,
          content_unit_id: content_unit_id,
          relevance: relevance,
          state: state
        )

        if content_topic.save
          { content_topic: content_topic, errors: [] }
        else
          { content_topic: nil, errors: content_topic.errors.full_messages }
        end
      end
    end
  end
end
