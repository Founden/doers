Doers::Application.routes.draw do
  easy_auth_routes
  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show]

  root :to => 'sessions#index'
end
