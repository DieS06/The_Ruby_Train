if Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(Rails.root.join("config/sidekiq.yml"))["schedule"]
end
