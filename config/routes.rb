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

  namespace :admin do
    resources :lessons, only: %i[edit update], param: :slug
  end

  require "sidekiq/web"
  authenticate :user, ->(u) { u.has_role?(:super_admin) || u.has_role?(:admin) } do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :users,
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    invitations: "users/invitations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    put "users/update_password", to: "users/registrations#update_password"
  end

  namespace :users do
    put "id/state", to: "registrations#update_state"
    put "update_info", to: "update_user#update"
  end

  resources :users do
    resources :roles, only: [ :index ]
  end

  resources :contact_messages, only: :create

  get "/profiles", to: "profiles#index"
  get "/content_units", to: "content_units#index", as: :content_units
  get "content_units/:slug", to: "content_units#show", as: :content_unit
  get "/evaluations", to: "evaluations#index"
  get "/evaluations/:id", to: "evaluations#show", as: :evaluation

  get "/users/password/edit", to: "home#profile", constraints: ->(req) { req.format.html? }
  get "/users/confirmation", to: "home#profile", constraints: ->(req) { req.format.html? }
  get "/users/invitation/accept", to: "home#profile", constraints: ->(req) { req.format.html? }
  get "/group_invitations/accept/:token", to: "group_invitations#accept", as: :accept_group_invitation

  root to: "home#index"
  get "*path", to: "home#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
