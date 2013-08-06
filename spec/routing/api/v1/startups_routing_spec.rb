require 'spec_helper'

describe Api::V1::StartupsController do

  describe 'routing' do

    it 'for all startups' do
      get('/api/v1/startups').should route_to('api/v1/startups#index')
    end

    it 'for creating an import job' do
      post('/api/v1/startups').should route_to('api/v1/startups#create')
    end

  end
end

