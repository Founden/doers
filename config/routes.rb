Doers::Application.routes.draw do
  easy_auth_routes
  get 'sign_in' => 'sessions#index'

end
