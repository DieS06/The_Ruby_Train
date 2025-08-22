source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"
gem "ruby-vips"

# ─── AUTH ───────────────────────────────────────────────
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.12"
gem "jsonapi-serializer"
gem "devise_invitable", "~> 2.0.0"
gem "cancancan", "~> 3.5"
gem "active_model_serializers", "~> 0.10.0"

# ─── OAUTH ──────────────────────────────────────────────
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# ─── ROLES ──────────────────────────────────────────────
gem "rolify", "~> 6.0"

# ─── STORAGE ────────────────────────────────────────────
gem "active_storage_validations"

# ─── GRAPHQL ────────────────────────────────────────────
gem "graphql"

# ─── NOTIFICATIONS ─────────────────────────────────────
gem "noticed"

# ─── BACKGROUND JOBS ────────────────────────────────────
gem "sidekiq"
gem "sidekiq-scheduler"
gem "sidekiq-cron"
gem "sidekiq-unique-jobs"
gem "sidekiq-throttled", "~> 2.0.0"
gem "redis", "~> 4.8"

# ─── TRACKING ───────────────────────────────────────────
gem "public_activity"

# ─── EVALUATION ────────────────────────────────────────
# gem "reform", require: "reform/rails"
# gem "reform-rails"
# gem "simple_form"

# ─── PAYMENTS ───────────────────────────────────────────
# gem "pay", "~> 10.1"
# gem "stripe", "~> 15.1"
# gem "receipts", "~> 2.0"
# gem "pgvector", "~> 0.3.2"
# gem "neighbor"

# ─── TRANSLATIONS ──────────────────────────────────────
gem "rails-i18n", "~> 8.0.0"

# ─── FRONTEND (Rails 8 compatible) ──────────────────────
gem "observer"
gem "shakapacker"
gem "react_on_rails"
gem "turbo-rails"
gem "stimulus-rails"

# ─── API / CORS ────────────────────────────────
gem "rack-cors"
gem "friendly_id"

# ─── PAGINATION ───────────────────────────────────────────
gem "kaminari"

group :development, :test do
  gem "debug", platforms: :mri
  gem "listen", "~> 3.7"
  gem "dotenv-rails"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 6.0"
  gem "fakesite", "~> 0.2.3"
  gem "factory_bot_rails"
  gem "faker"
  gem "graphiql-rails"
  gem "yard", "~> 0.9"
  gem "yard-rails"
  gem "annotate"
end

group :development do
  gem "web-console"
  gem "i18n-tasks", "~> 1.0.15"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
