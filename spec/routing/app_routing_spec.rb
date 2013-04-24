require 'spec_helper'

describe 'Application' do

  describe 'routing' do

    it 'for main page' do
      get('/').should route_to('pages#dashboard')
    end

  end
end

