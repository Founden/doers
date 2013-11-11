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
    include AvatarHelper

    let(:user_id) { user.id }
    # Some data to make sure nothing brakes
    let!(:board) { Fabricate(:board, :user => user) }

    before { get(:show, :id => user_id) }

    subject(:api_user) { json_to_ostruct(response.body, :user) }

    shared_examples 'shows current user details' do
      its('keys.size') { should eq(13) }
      its(:id) { should eq(user.id) }
      its(:nicename) { should eq(user.nicename) }
      its(:email) { should eq(user.email) }
      its('external_id.to_i') { should eq(user.external_id) }
      its(:angel_list_token) { should eq(user.identities.first.token) }
      its(:is_importing) { should be_false }
      its(:is_admin) { should eq(user.admin?) }
      its(:avatar_url) { should eq(avatar_uri(user)) }
      its('created_project_ids.size') {
        should eq(user.created_project_ids.count) }
      its('shared_project_ids.size') {
        should eq(user.shared_projects.count) }
      its('activity_ids.size') { should eq(user.activities.count) }
      its('invitation_ids.size') { should eq(user.invitations.count) }
      its('membership_ids.size') { should eq(user.memberships.count) }
    end

    context 'if user owns the profile' do
      it_should_behave_like 'shows current user details'
    end

    context 'if profile id is not found' do
      let(:user_id) { 'mine' }
      it_should_behave_like 'shows current user details'
    end

    context 'shows limited details for foreign profile' do
      let(:some_user) { Fabricate(:user) }
      let(:user_id) { some_user.id }

      its('keys.size') { should eq(5) }
      its(:id) { should eq(some_user.id) }
      its(:nicename) { should eq(some_user.nicename) }
      its(:is_importing) { should be_false }
      its(:avatar_url) { should eq(gravatar_uri(some_user.email)) }
    end
  end
end
