Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # cámbialo a tu frontend real en producción

    resource '*',
      headers: :any,
      expose: ['Authorization'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end
