require 'spec_helper'

describe Api::V1::BoardsController do

  describe 'routing' do

    it 'for showing one board' do
      get('/api/v1/boards/1').should route_to('api/v1/boards#show', :id => '1')
    end

    it 'for creating a board' do
      post('/api/v1/boards').should route_to('api/v1/boards#create')
    end

    it 'for updating a board' do
      patch('/api/v1/boards/1').should route_to(
        'api/v1/boards#update', :id => '1')
    end

    it 'for board deletion' do
      delete('/api/v1/boards/1').should route_to(
        'api/v1/boards#destroy', :id => '1')
    end

  end
end

