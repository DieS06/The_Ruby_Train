class TestJob < ApplicationJob
  queue_as :default

  def perform(message)
    Rails.logger.info "✅ TestJob ejecutado con: #{message}"
  end
end