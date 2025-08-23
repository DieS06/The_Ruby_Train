require_relative "boot"

require "rails/all"
require_relative "../lib/jwt_cookie_to_header"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TheRubyTrain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # i18n Translations configuration
    # See https://guides.rubyonrails.org/i18n.html
    config.i18n.available_locales = [ :en, :es ]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [ :es ]

    # Sidekiq configuration
    config.active_job.queue_adapter = :sidekiq

    # Active Job Mail Queues
    config.active_job.queue_adapter = :sidekiq

    # Cookie Loader to Header Middleware
    config.eager_load_paths << Rails.root.join("lib")
    config.middleware.insert_before Warden::Manager, JwtCookieToHeader

    # Active Storage
    config.active_storage.variant_processor = :vips
  end
end
