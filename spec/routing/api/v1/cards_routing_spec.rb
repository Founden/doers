require 'spec_helper'

describe Api::V1::CardsController do

  describe 'routing' do

    it 'for showing all cards' do
      get('/api/v1/cards').should route_to('api/v1/cards#index')
    end

    it 'for showing one card' do
      get('/api/v1/cards/1').should route_to('api/v1/cards#show', :id => '1')
    end

    it 'for creating a card' do
      post('/api/v1/cards').should route_to('api/v1/cards#create')
    end

    it 'for updating a card' do
      patch('/api/v1/cards/1').should route_to('api/v1/cards#update',:id => '1')
    end

    it 'for card deletion' do
      delete('/api/v1/cards/1').should route_to(
        'api/v1/cards#destroy', :id => '1')
    end

  end
end

