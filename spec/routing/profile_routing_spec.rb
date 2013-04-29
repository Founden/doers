require 'spec_helper'

describe ProfilesController do

  describe 'routing' do

    it 'for a user' do
      get('/profiles/1').should route_to('profiles#show', :id => '1')
    end

    it 'for current user' do
      get('/profiles/mine').should route_to('profiles#mine')
    end

  end
end

