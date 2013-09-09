require 'spec_helper'

describe Api::V1::CommentsController do

  describe 'routing' do

    it 'for showing comments' do
      get('/api/v1/comments').should route_to('api/v1/comments#index')
    end

    it 'for showing a comment' do
      get('/api/v1/comments/1').should route_to(
        'api/v1/comments#show', :id => '1')
    end

    it 'for creating a comment' do
      post('/api/v1/comments').should route_to('api/v1/comments#create')
    end

    it 'for comment deletion' do
      delete('/api/v1/comments/1').should route_to(
        'api/v1/comments#destroy', :id => '1')
    end

  end
end

