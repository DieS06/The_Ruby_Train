Rails.application.routes.draw do
  # get "home/index"
  get "/up/full", to: ->(_) do
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      [200, {}, ["OK"]]
    rescue => e
      [500, {}, ["DB DOWN: #{e.message}"]]
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: 'users/confirmations',
    invitations: 'users/invitations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  namespace :users do
    put "id/state", to: "registrations#update_state"
  end

  resources :profiles, only: [:show, :update]
  get "/profile", to: "profiles#me"

  resources :roles, only: [] do
    collection do
      post :assign_role
      delete :remove_role
      get :index
    end
  end
  
  root to: "home#index"
end
