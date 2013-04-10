require 'spec_helper'

describe ProfilesController do

  describe 'routing' do

    it 'for a user' do
      get('/profiles/1').should route_to('profiles#show', :id => '1')
    end

  end
end

