module Helpers
  module CanCanHelper
    def ability
      @ability ||= Ability.new(context[:current_user])
    end
  end
end
