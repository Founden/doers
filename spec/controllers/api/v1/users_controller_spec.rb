require 'spec_helper'

describe Api::V1::UsersController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before { get(:index) }

    subject(:api_user) { json_to_ostruct(response.body) }

    its('users.count') { should eq(1) }
  end

  describe '#show' do
    include GravatarHelper

    before { get(:show, :id => user.id) }

    subject(:api_user) { json_to_ostruct(response.body, :user) }

    its('keys.size') { should eq(7) }
    its(:id) { should eq(user.id) }
    its(:nicename) { should eq(user.nicename) }
    its(:external_id) { should eq(user.external_id) }
    its(:angel_list_token) { should eq(user.identities.first.token) }
    its(:isImporting) { should be_false }
    its(:avatar_url) { should eq(gravatar_uri(user.email)) }
    its(:is_admin) { should eq(user.admin?) }
  end
end
