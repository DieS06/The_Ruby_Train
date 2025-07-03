Rails.application.routes.draw do
  get "/up/full", to: ->(_) do
      begin
        ActiveRecord::Base.connection.execute("SELECT 1")
        [ 200, {}, [ "OK" ] ]
      rescue => e
        [ 500, {}, [ "DB DOWN: #{e.message}" ] ]
      end
  end

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    invitations: "users/invitations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  namespace :users do
    put "id/state", to: "registrations#update_state"
  end

  resources :users do
    resource :roles, only: :index
  end

  get "/profiles", to: "profiles#index"

  get "/users/password/edit", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/confirmation", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/invitation/accept", to: "home#index", constraints: ->(req) { req.format.html? }

  root to: "home#index"
  get "*path", to: "home#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
