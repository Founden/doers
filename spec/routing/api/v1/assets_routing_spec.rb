require 'spec_helper'

describe Api::V1::AssetsController do

  describe 'routing' do

    it 'for creating an asset' do
      post('/api/v1/assets').should route_to('api/v1/assets#create')
    end

    it 'for showing assets' do
      get('/api/v1/assets').should route_to('api/v1/assets#index')
    end

    it 'for showing one asset' do
      get('/api/v1/assets/1').should route_to('api/v1/assets#show', :id => '1')
    end

    it 'for asset deletion' do
      delete('/api/v1/assets/1').should route_to(
        'api/v1/assets#destroy', :id => '1')
    end

  end
end

