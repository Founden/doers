require 'spec_helper'

describe 'OAuth' do
  describe 'routing' do
    it 'for authorization creation' do
      post('/oauth/authorize').should route_to(
        'doorkeeper/authorizations#create')
    end

    it 'for authorization deletion' do
      delete('/oauth/authorize').should route_to(
        'doorkeeper/authorizations#destroy')
    end

    it 'for new authorization' do
      get('/oauth/authorize').should route_to(
        'doorkeeper/authorizations#new')
    end

    it 'for authorization code' do
      get('/oauth/authorize/CODE').should route_to(
        'doorkeeper/authorizations#show', :code => 'CODE')
    end

    it 'for token creation' do
      post('/oauth/token').should route_to('doorkeeper/tokens#create')
    end

    it 'for token info' do
      get('/oauth/token/info').should route_to('doorkeeper/token_info#show')
    end
  end
end
