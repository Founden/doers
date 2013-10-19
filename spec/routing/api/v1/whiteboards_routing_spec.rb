require 'spec_helper'

describe Api::V1::WhiteboardsController do

  describe 'routing' do

    it 'for showing whiteboards' do
      get('/api/v1/whiteboards').should route_to('api/v1/whiteboards#index')
    end

    it 'for showing a whiteboard' do
      get('/api/v1/whiteboards/1').should route_to(
        'api/v1/whiteboards#show', :id => '1')
    end

    it 'for creating a whiteboard' do
      post('/api/v1/whiteboards').should route_to('api/v1/whiteboards#create')
    end

    it 'for updating a whiteboard' do
      patch('/api/v1/whiteboards/1').should route_to(
        'api/v1/whiteboards#update', :id => '1')
    end

    it 'for deleting a whiteboard' do
      delete('/api/v1/whiteboards/1').should route_to(
        'api/v1/whiteboards#destroy', :id => '1')
    end

  end
end

