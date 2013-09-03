require 'spec_helper'

describe Api::V1::InvitationsController do

  describe 'routing' do

    it 'for showing invitations' do
      get('/api/v1/invitations').should route_to('api/v1/invitations#index')
    end

    it 'for showing an invitation' do
      get('/api/v1/invitations/1').should route_to(
        'api/v1/invitations#show', :id => '1')
    end

    it 'for creating an invitation' do
      post('/api/v1/invitations').should route_to('api/v1/invitations#create')
    end

    it 'for invitation deletion' do
      delete('/api/v1/invitations/1').should route_to(
        'api/v1/invitations#destroy', :id => '1')
    end

  end
end

