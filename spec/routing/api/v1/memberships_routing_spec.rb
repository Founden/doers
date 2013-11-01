require 'spec_helper'

describe Api::V1::MembershipsController do

  describe 'routing' do

    it 'for showing memberships' do
      get('/api/v1/memberships').should route_to('api/v1/memberships#index')
    end

    it 'for showing a membership' do
      get('/api/v1/memberships/1').should route_to(
        'api/v1/memberships#show', :id => '1')
    end

    it 'for membership update' do
      put('/api/v1/memberships/1').should route_to(
        'api/v1/memberships#update', :id => '1')
    end

    it 'for membership deletion' do
      delete('/api/v1/memberships/1').should route_to(
        'api/v1/memberships#destroy', :id => '1')
    end

  end
end

