# frozen_string_literal: true

# == UpdateStateContentTopic Mutation
#
# @!group 03-GraphQL / Mutations / ContentTopic
#
# Updates only the `state` of a specific ContentTopic relation.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] ID of the content topic to update.
# @!attribute [r] state
#   @return [String] New state value (e.g. draft, published, archived).
#
# === Returns
# @!attribute [r] content_topic
#   @return [Types::ContentTopicType] The updated ContentTopic object.
# @!attribute [r] errors
#   @return [Array<String>] Any validation errors encountered.
#
# @example
#   mutation {
#     updateStateContentTopic(id: 1, state: "published") {
#       contentTopic {
#         id
#         state
#       }
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class UpdateStateContentTopic < Base::BaseMutation
      argument :id, ID, required: true
      argument :state, String, required: true

      field :content_topic, Types::Topic::ContentTopicType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, state:)
        content_topic = ::ContentTopic.find_by(id: id)

        return { content_topic: nil, errors: [ "Not found" ] } unless content_topic

        if content_topic.update(state: state)
          { content_topic: content_topic, errors: [] }
        else
          { content_topic: nil, errors: content_topic.errors.full_messages }
        end
      end
    end
  end
end
