# frozen_string_literal: true

# == ListTopicsByContentUnit Query
#
# @!group 04-GraphQL / Queries / ContentTopic
#
# Lists all topics linked to a specific ContentUnit via ContentTopic.
#
# === Arguments
# @!attribute [r] content_unit_id
#   @return [ID] Required. ID of the content unit.
#
# === Returns
# @!attribute [r] content_topics
#   @return [[Types::ContentTopicType]] Array of ContentTopic relations for the unit.
#
# @example GraphQL query
#   query {
#     listTopicsByContentUnit(contentUnitId: 1) {
#       id
#       relevance
#       topic {
#         name
#       }
#     }
#   }
#
# @!endgroup
#
module Queries
  module Topic
    class ListTopicsByContentUnit < GraphQL::Schema::Resolver
      type [ Types::Topic::ContentTopicType ], null: false
      argument :content_unit_id, ID, required: true

      def resolve(content_unit_id:)
        ::ContentTopic.includes(:topic).where(content_unit_id: content_unit_id)
      end
    end
  end
end
