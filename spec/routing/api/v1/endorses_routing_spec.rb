require 'spec_helper'

describe Api::V1::EndorsesController do

  describe 'routing' do

    it 'for showing endorses' do
      get('/api/v1/endorses').should route_to('api/v1/endorses#index')
    end

    it 'for showing an endorse' do
      get('/api/v1/endorses/1').should route_to(
        'api/v1/endorses#show', :id => '1')
    end

    it 'for creating an endorse' do
      post('/api/v1/endorses').should route_to('api/v1/endorses#create')
    end

    it 'for deleting an endorse' do
      delete('/api/v1/endorses/1').should route_to(
        'api/v1/endorses#destroy', :id => '1')
    end

  end
end

