require 'spec_helper'

describe Api::V1::StartupsController do

  describe 'routing' do

    it 'for creating an import job' do
      post('/api/v1/startups').should route_to('api/v1/startups#create')
    end

  end
end

