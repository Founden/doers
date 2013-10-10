require 'spec_helper'

describe Api::V1::TopicsController do

  describe 'routing' do

    it 'for showing available topics' do
      get('/api/v1/topics').should route_to('api/v1/topics#index')
    end

    it 'for showing one topic' do
      get('/api/v1/topics/1').should route_to('api/v1/topics#show', :id => '1')
    end

    it 'for creating a topic' do
      post('/api/v1/topics').should route_to('api/v1/topics#create')
    end

    it 'for updating a topic' do
      patch('/api/v1/topics/1').should route_to(
        'api/v1/topics#update', :id => '1')
    end

    it 'for topic deletion' do
      delete('/api/v1/topics/1').should route_to(
        'api/v1/topics#destroy', :id => '1')
    end

  end
end

