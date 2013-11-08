require 'spec_helper'

describe PagesController do

  describe 'routing' do
    it 'for dashboard' do
      get('/dashboard').should route_to('pages#dashboard')
    end

    it 'for waiting page' do
      get('/waiting').should route_to('pages#waiting')
    end

    it 'for waiting page (PATCH)' do
      patch('/waiting').should route_to('pages#waiting')
    end

    it 'for export page' do
      get('/export').should route_to('pages#export')
    end

    it 'for download page' do
      get('/download').should route_to('pages#download')
    end

    it 'for stats page' do
      get('/stats').should route_to('pages#stats')
    end

  end
end
