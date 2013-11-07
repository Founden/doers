Doers::Application.routes.draw do
  # Easy Auth endpoints
  # Allow only Angel List to avoid exceptions.
  constraints(:provider => :angel_list) do
    easy_auth_routes
  end

  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show, :update, :edit] do
    get :mine, :on => :collection
    get :notifications, :on => :collection
    patch :notifications, :on => :collection
  end
  resource :pages, :only => [], :path => '/' do
    get :dashboard
    get :waiting
    patch :waiting
    get :export
    get :download
    get :promo_code
    patch :promo_code
  end

  namespace :api, :constraints => {:format => :json} do
    namespace :v1 do
      resources(:users, :only => [:index, :show])
      resources(:projects)
      resources(:startups, :only => [:create, :index])
      resources(:boards)
      resources(:cards)
      resources(:assets)
      resources(:teams, :only => [:index, :show])
      resources(:embeds, :only => [:index])
      resources(:activities, :except => [:create, :update])
      resources(:invitations, :except => [:update])
      resources(:memberships, :only => [:index, :show, :update, :destroy])
      resources(:comments, :except => [:update])
      resources(:topics)
      resources(:endorses, :except => [:update])
      resources(:whiteboards)
    end
  end

  root :to => 'pages#dashboard'
end
