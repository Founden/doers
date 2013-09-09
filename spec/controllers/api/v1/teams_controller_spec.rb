require 'spec_helper'

describe Api::V1::TeamsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before { get(:index) }

    subject(:api_user) { json_to_ostruct(response.body) }

    it { should be_nil }
  end

  describe '#show' do
    let(:team) { Fabricate(:team) }
    let(:team_id) { team.id }

    before { get(:show, :id => team_id) }

    subject(:api_team) { json_to_ostruct(response.body, :team) }

    its('keys.size') { should eq(9) }
    its(:id) { should eq(team.id) }
    its(:slug) { should eq(team.slug) }
    its(:title) { should eq(team.title) }
    its(:description) { should eq(team.description) }
    its(:website) { should eq(team.website) }
    its(:angel_list) { should eq(team.angel_list) }
    its(:banner_id) { should eq(team.banner.id) }
    its('user_ids.size') { should eq(team.boards.count) }
    its('board_ids.size') { should eq(team.boards.count) }
  end
end
