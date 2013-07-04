require 'spec_helper'

describe Api::V1::ProjectsController do

  describe 'routing' do

    it 'for showing all projects' do
      get('/api/v1/projects').should route_to('api/v1/projects#index')
    end

    it 'for showing one project' do
      get('/api/v1/projects/1').should route_to(
        'api/v1/projects#show', :id => '1')
    end

    it 'for creating a project' do
      post('/api/v1/projects').should route_to('api/v1/projects#create')
    end

    it 'for updating a project' do
      patch('/api/v1/projects/1').should route_to(
        'api/v1/projects#update', :id => '1')
    end

    it 'for project deletion' do
      delete('/api/v1/projects/1').should route_to(
        'api/v1/projects#destroy', :id => '1')
    end

  end
end

