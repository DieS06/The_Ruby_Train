RSpec.configure do |config|
  config.before(:suite) { Rails.application.load_tasks && Rake::Task["db:test:prepare"].invoke }
end
