require 'spec_helper'

describe SessionsController do

  describe 'routing' do
    it 'for sign_out' do
      get('/sign_out').should route_to('sessions#destroy')
    end

    it 'for sign_in' do
      get('/sign_in').should route_to('sessions#index')
    end

    it 'for angel_list sign_in' do
      get('/sign_in/oauth2/angel_list').should route_to(
        'sessions#new', :identity => :oauth2, :provider => 'angel_list')
    end

    it 'for angel_list sign_in callback' do
      get('/sign_in/oauth2/angel_list/callback').should route_to(
        'sessions#create', :identity => :oauth2, :provider => 'angel_list')
    end

  end
end
