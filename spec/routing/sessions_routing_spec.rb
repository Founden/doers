require 'spec_helper'

describe SessionsController do

  describe 'routing' do
    it 'for sign_out' do
      get('/sign_out').should route_to('sessions#destroy')
    end

    it 'for sign_in' do
      get('/sign_in').should route_to('sessions#index')
    end

    it 'for twitter sign_in' do
      get('/sign_in/oauth/twitter').should route_to(
        'sessions#new', :identity => :oauth, :provider => 'twitter')
    end

    it 'for twitter sign_in callback' do
      get('/sign_in/oauth/twitter/callback').should route_to(
        'sessions#create', :identity => :oauth, :provider => 'twitter')
    end

  end
end
