# frozen_string_literal: true

# == UpdateStateTopic Mutation
#
# @!group 02-GraphQL / Mutations / Topic
#
# Updates only the `state` of a Topic by ID. Useful to synchronize with ContentUnit state.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] Required. ID of the topic to update.
# @!attribute [r] state
#   @return [String] Required. New state (draft, published, archived, deleted).
#
# === Returns
# @!attribute [r] topic
#   @return [Types::TopicType] The updated topic with new state.
# @!attribute [r] errors
#   @return [Array<String>] Validation or update errors.
#
# @example GraphQL mutation
#   mutation {
#     updateStateTopic(id: 1, state: "published") {
#       topic {
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
    class UpdateStateTopic < Base::BaseMutation
      argument :id, ID, required: true
      argument :state, String, required: true

      field :topic, Types::Topic::TopicType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, state:)
        topic = ::Topic.find_by(id: id)
        return { topic: nil, errors: [ "Topic not found" ] } unless topic

        if topic.update(state: state)
          { topic: topic, errors: [] }
        else
          { topic: nil, errors: topic.errors.full_messages }
        end
      end
    end
  end
end
