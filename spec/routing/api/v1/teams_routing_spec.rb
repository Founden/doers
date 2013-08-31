require 'spec_helper'

describe Api::V1::TeamsController do

  describe 'routing' do

    it 'for showing teams' do
      get('/api/v1/teams').should route_to('api/v1/teams#index')
    end

    it 'for showing a team' do
      get('/api/v1/teams/1').should route_to('api/v1/teams#show', :id => '1')
    end

  end
end

