require 'spec_helper'

describe Api::V1::UsersController do

  describe 'routing' do

    it 'for showing users' do
      get('/api/v1/users').should route_to('api/v1/users#index')
    end

    it 'for showing an user' do
      get('/api/v1/users/1').should route_to('api/v1/users#show', :id => '1')
    end

  end
end

