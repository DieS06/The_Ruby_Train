# frozen_string_literal: true

#
# @!group 02 - Test / CanCanCan
#
# Helpers to stub current_ability in controllers during request specs.}
#

module AbilityStubHelper
  def stub_ability!(controller, &block)
    ability = Class.new.include(CanCan::Ability).new
    block.call(ability)
    allow(controller).to receive(:current_ability).and_return(ability)
  end
end

RSpec.configure do |config|
  config.include AbilityStubHelper, type: :request
end
# @!endgroup
