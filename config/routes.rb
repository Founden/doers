Doers::Application.routes.draw do
  # OAuth 2.0 endpoints
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end

  # Easy Auth endpoints
  easy_auth_routes

  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show, :update]
  resource :pages, :only => [], :path => '/' do
    get :dashboard
  end

  root :to => 'pages#dashboard'
end
