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

  require "sidekiq/web"
  authenticate :user, ->(u) { u.has_role?(:super_admin) || u.has_role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :users,
  # path: "", path_names: {
  #   sign_in: "login",
  #   sign_out: "logout",
  #   registration: "signup"
  # },
  controllers: {
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
    resources :roles, only: [ :index ]
  end

  get "/profiles", to: "profiles#index"

  get "/users/password/edit", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/confirmation", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/invitation/accept", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/group_invitations/accept/:token", to: "group_invitations#accept", as: :accept_group_invitation

  root to: "home#index"
  get "*path", to: "home#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
