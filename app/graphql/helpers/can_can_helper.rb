module Helpers
  module CanCanHelper
    def ability
      @ability ||= Ability.new(context[:current_user])
    end

    def authorize!(action, subject)
      raise GraphQL::ExecutionError, "Unauthorized" unless ability.can?(action, subject)
    end

    def current_user
      context[:current_user]
    end
  end
end
