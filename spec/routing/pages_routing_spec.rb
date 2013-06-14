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

  end
end

