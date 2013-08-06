Doers::Application.routes.draw do
  # Easy Auth endpoints
  # Allow only Angel List to avoid exceptions.
  constraints(:provider => :angel_list) do
    easy_auth_routes
  end

  get 'sign_in' => 'sessions#index'

  resources :profiles, :only => [:show, :update, :edit] do
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
      resources(:projects)
      resources(:startups, :only => [:create, :index])
      resources(:boards)
      resources(:cards)
      resources(:assets)
      resources(:embeds, :only => [:index])
    end
  end

  root :to => 'pages#dashboard'
end
