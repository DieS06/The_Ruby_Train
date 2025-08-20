# frozen_string_literal: true

# == ListTopics Query
#
# @!group 04-GraphQL / Queries / Topic
#
# Returns a list of all topics in the system.
#
# === Returns
# @!attribute [r] topics
#   @return [[Types::TopicType]] List of topics.
#
# @example GraphQL query
#   query {
#     listTopics {
#       id
#       name
#       position
#       state
#     }
#   }
#
# @!endgroup
#
module Queries
  module Topic
    class ListTopics < GraphQL::Schema::Resolver
      type [ Types::Topic::TopicType ], null: false

      def resolve
        ::Topic.all.order(:position)
      end
    end
  end
end
