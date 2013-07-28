require 'spec_helper'

describe Api::V1::EmbedsController do

  describe 'routing' do

    it 'for showing an embed' do
      get('/api/v1/embeds/').should route_to('api/v1/embeds#index')
    end
  end
end

