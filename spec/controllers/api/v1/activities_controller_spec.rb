require 'spec_helper'

describe Api::V1::ActivitiesController, :use_truncation do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:ids) { user.activities.pluck('id') }

    before { get(:index, :ids => ids) }

    subject(:api_user) { json_to_ostruct(response.body) }

    its('activities.count') { should eq(1) }
  end

  describe '#show' do
    let(:activity_id) { activity.id }
    let(:activity) { user.activities.first }

    before { get(:show, :id => activity_id) }

    subject(:api_activity) { json_to_ostruct(response.body, :activity) }

    its('keys.size') { should eq(14) }
    its(:id) { should eq(activity.id) }
    its(:slug) { should eq(activity.slug) }
    its(:user_id) { should eq(user.id) }
    its(:project_id) { should be_nil }
    its(:board_id) { should be_nil }
    its(:comment_id) { should be_nil }
    its(:card_id) { should be_nil }
    its(:topic_id) { should be_nil }
    its(:user_name) { should eq(user.nicename) }
    its(:project_title) { should be_nil }
    its(:board_title) { should be_nil }
    its(:topic_title) { should be_nil }
    its(:updated_at) { should_not be_blank }
  end

  describe '#destroy' do
    let(:activity) { user.activities.first }
    let(:activity_id) { activity.id }

    before { delete(:destroy, :id => activity_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'board is not owned by current user' do
      let(:activity_id) { Fabricate(:user).activities.first.id }

      its('response.status') { should eq(400) }
    end
  end
end
