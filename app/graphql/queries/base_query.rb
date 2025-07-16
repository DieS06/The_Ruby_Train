# frozen_string_literal: true

# == BaseQuery
#
# @!group 03-GraphQL / Base
#
# Abstract base class for GraphQL queries.
# Provides authorization and error handling helpers.
#
# @example Basic usage
#   class Queries::User::FindAll < Queries::BaseQuery
#     type [Types::User::UserType], null: false
#
#     def resolve
#       User.all
#     end
#   end
#
# @!endgroup
#

module Queries
  class BaseQuery < GraphQL::Schema::Resolver
    include Helpers::CanCanHelper
    # Inject current_user to all queries
    def current_user
      context[:current_user]
    end

    # Generic authorization check
    def authorize!(action, record)
      unless current_user&.can?(action, record)
        raise GraphQL::ExecutionError, "You are not authorized to perform this action."
      end
    end
  end
end
