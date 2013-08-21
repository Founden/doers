require 'spec_helper'

describe Api::V1::ActivitiesController do

  describe 'routing' do

    it 'for showing activities' do
      get('/api/v1/activities').should route_to('api/v1/activities#index')
    end

    it 'for showing an activity' do
      get('/api/v1/activities/1').should route_to(
        'api/v1/activities#show', :id => '1')
    end

    it 'for deleting an activity' do
      delete('/api/v1/activities/1').should route_to(
        'api/v1/activities#destroy', :id => '1')
    end

  end
end

