require 'spec_helper'

describe ProfilesController do

  describe 'routing' do

    it 'for a wrong ID' do
      get('/profiles/1').should_not route_to('profiles#mine')
    end

    it 'for current user' do
      get('/profiles/mine').should route_to('profiles#mine')
    end

    it 'for user notifications with wrong profile ID' do
      get('/profiles/2/notifications').should_not route_to(
        'profiles#notifications', :profile_id => 'mine')
    end

    it 'for user notifications' do
      get('/profiles/mine/notifications').should route_to(
        'profiles#notifications', :profile_id => 'mine')
    end

  end
end

