class JwtCookieToHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    cookie = Rack::Request.new(env).cookies["access_token"]
    if cookie&.start_with?("eyJ")
      env["HTTP_AUTHORIZATION"] ||= "Bearer #{cookie}"
    end
    @app.call(env)
  end
end
