# frozen_string_literal: true

# == FindTopic Query
#
# @!group 02-GraphQL / Queries / Topic
#
# Retrieves a single Topic by its ID.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] Required. ID of the topic to fetch.
#
# === Returns
# @!attribute [r] topic
#   @return [Types::TopicType] The requested topic, if found.
#
# @example GraphQL query
#   query {
#     findTopic(id: 1) {
#       id
#       name
#       description
#       position
#       state
#     }
#   }
#
# @!endgroup
#

module Queries
  module Topic
    class FindTopic < GraphQL::Schema::Resolver
      type Types::Topic::TopicType, null: true
      argument :id, ID, required: true

      def resolve(id:)
        ::Topic.find_by(id: id)
      end
    end
  end
end
