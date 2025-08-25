# frozen_string_literal: true

# @!group 02 - Test / Devise
#
# Provides Devise helpers for request specs.
#

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
end
# @!endgroup
