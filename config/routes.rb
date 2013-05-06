Doers::Application.routes.draw do
  # Easy Auth endpoints
  easy_auth_routes

  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show, :update] do
    get :mine, :on => :collection
  end
  resource :pages, :only => [], :path => '/' do
    get :dashboard
  end

  root :to => 'pages#dashboard'
end
