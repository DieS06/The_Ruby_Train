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
  end
end
