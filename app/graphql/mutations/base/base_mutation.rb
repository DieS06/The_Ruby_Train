# frozen_string_literal: true

module Mutations
  module Base
    class BaseMutation < GraphQL::Schema::Mutation
      include Helpers::CanCanHelper
      argument_class Types::BaseArgument
      field_class Types::BaseField
      object_class Types::BaseObject
    end
  end
end
