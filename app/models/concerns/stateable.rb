# frozen_string_literal: true

# == Stateable Concern
#
# Provides unified state management functionality for models.
# Eliminates duplication across StateContent, StateGroup, and StateMembership concerns.
#
# @example Usage in a model
#   class MyModel < ApplicationRecord
#     include Stateable
#
#     define_state_enum({
#       draft: 0,
#       published: 1,
#       archived: 2
#     })
#   end
#
# This will automatically generate:
# - Enum definition
# - Predicate methods (draft?, published?, archived?)
# - Scopes (draft, published, archived)
# - State validation
#

module Stateable
  extend ActiveSupport::Concern

  included do
    validates :state, presence: true
  end

  class_methods do
    # Defines state enum with Rails built-in functionality
    #
    # @param states_hash [Hash] Hash of state names and values
    # @example
    #   define_state_enum({ draft: 0, published: 1, archived: 2 })
    def define_state_enum(states_hash)
      # Rails enum automatically creates:
      # - Predicate methods (draft?, published?, etc.)
      # - Scopes (draft, published, etc.)
      # - Constants and helper methods
      enum :state, states_hash
    end
  end
end
