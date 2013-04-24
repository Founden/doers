require 'spec_helper'

describe PagesController do

  describe 'routing' do

    it 'for dashboard' do
      get('/dashboard').should route_to('pages#dashboard')
    end

  end
end

