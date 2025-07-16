# frozen_string_literal: true

# == UpdateRelevanceContentTopic Mutation
#
# @!group 03-GraphQL / Mutations / ContentTopic
#
# Updates the `relevance` value of a specific ContentTopic.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] ID of the content_topic to update.
# @!attribute [r] relevance
#   @return [Integer] New relevance value (1–5).
#
# === Returns
# @!attribute [r] content_topic
#   @return [Types::ContentTopicType] The updated ContentTopic object.
# @!attribute [r] errors
#   @return [Array<String>] Any validation errors.
#
# @example
#   mutation {
#     updateRelevanceContentTopic(id: 2, relevance: 4) {
#       contentTopic {
#         id
#         relevance
#       }
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class UpdateRelevanceContentTopic < Base::BaseMutation
      argument :id, ID, required: true
      argument :relevance, Integer, required: true

      field :content_topic, Types::Topic::ContentTopicType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, relevance:)
        content_topic = ::ContentTopic.find_by(id: id)
        return { content_topic: nil, errors: [ "Not found" ] } unless content_topic

        if content_topic.update(relevance: relevance)
          { content_topic: content_topic, errors: [] }
        else
          { content_topic: nil, errors: content_topic.errors.full_messages }
        end
      end
    end
  end
end
