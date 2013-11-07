require 'spec_helper'

describe ProfilesController do

  describe 'routing' do

    it 'for a user' do
      get('/profiles/1').should route_to('profiles#show', :id => '1')
    end

    it 'for current user' do
      get('/profiles/mine').should route_to('profiles#mine')
    end

    it 'for editing user' do
      get('/profiles/1/edit').should route_to('profiles#edit', :id => '1')
    end

    it 'for user notifications' do
      get('/profiles/notifications').should route_to('profiles#notifications')
    end

  end
end

