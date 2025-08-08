require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end
  config.cache_store = :memory_store
  # Active Storage configuration
  config.active_storage.service = :local
  config.active_storage.service = :test
  # config.active_storage.service = :amazon

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true

  #------------------------------------------------------------------------------------------------
  # ACTION MAILER  CONFIGURATION
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.navigational_formats = []

  config.action_mailer.smtp_settings = {
    address:              ENV.fetch("SMTP_ADDRESS"),
    port:                 ENV.fetch("SMTP_PORT"),
    domain:               ENV.fetch("SMTP_DOMAIN"),
    user_name:            ENV.fetch("SMTP_USERNAME"),
    password:             ENV.fetch("SMTP_PASSWORD"),
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Static Assets
  config.public_file_server.enabled = true

  # Logs de Rails a STDOUT
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    config.log_level = :debug
    config.log_tags  = [ :request_id ]
    config.logger    = ActiveSupport::Logger.new($stdout)
  end

  # Sidekiq
  config.active_job.queue_adapter =
  ENV.fetch("SIDEKIQ_ENABLED", "false") == "true" ? :sidekiq : :inline

  # Blob Routes
  Rails.application.routes.default_url_options = {
    host: "localhost",
    port: 3000
  }
end
