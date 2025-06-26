Rails.application.routes.draw do
  get "/up/full", to: ->(_) do
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      [ 200, {}, [ "OK" ] ]
    rescue => e
      [ 500, {}, [ "DB DOWN: #{e.message}" ] ]
    end
  end

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

  patch "/profiles/me", to: "profiles#update_me"
  get "/profiles/me", to: "profiles#me", as: :my_profile
  resources :profiles, only: [ :show ]

  resources :roles, only: [] do
    collection do
      post :assign_role
      delete :remove_role
      get :index
    end
  end

  get "/users/password/edit", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/confirmation", to: "home#index", constraints: ->(req) { req.format.html? }
  get "/users/invitation/accept", to: "home#index", constraints: ->(req) { req.format.html? }


  root to: "home#index"
  get "*path", to: "home#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
