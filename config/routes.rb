Doers::Application.routes.draw do
  # Easy Auth endpoints
  easy_auth_routes

  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show, :update] do
    get :mine, :on => :collection
  end
  resource :pages, :only => [], :path => '/' do
    get :dashboard
    get :waiting
    patch :waiting
  end

  namespace :api, :constraints => {:format => :json} do
    namespace :v1 do
      resources(:users, :only => [:index, :show])
      resources(:projects, :only => [:index, :show, :create, :update])
    end
  end

  root :to => 'pages#dashboard'
end
