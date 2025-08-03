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
    # Defines state enum with automatic predicate methods and scopes
    #
    # @param states_hash [Hash] Hash of state names and values
    # @example
    #   define_state_enum({ draft: 0, published: 1, archived: 2 })
    def define_state_enum(states_hash)
      # Define the Rails enum
      enum :state, states_hash

      # Generate predicate methods and scopes for each state
      states_hash.keys.each do |state_name|
        # Define predicate method (e.g., draft?)
        define_method "#{state_name}?" do
          state == state_name.to_s
        end

        # Define scope (e.g., scope :draft)
        scope state_name, -> { where(state: state_name) }
      end
    end
  end
end
