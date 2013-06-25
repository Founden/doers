require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before { get(:index) }

    it 'serializes current user as a list into a json' do
      users = JSON.parse(response.body)['users']
      users.count.should eq(1)
    end
  end

  describe '#show' do
    before { get(:show, :id => user.id) }

    it 'serializes current user into a json' do
      api_user = JSON.parse(response.body)['user']
      api_user.keys.count.should eq(5)

      api_user['id'].should eq(user.id)
      api_user['nicename'].should eq(user.name)
      api_user['angel_list_id'].should eq(user.angel_list_id)
      api_user['angel_list_token'].should eq(user.identities.first.token)
      api_user['importing'].should be_false
    end
  end
end
