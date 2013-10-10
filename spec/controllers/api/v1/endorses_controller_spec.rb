require 'spec_helper'

describe Api::V1::EndorsesController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:ids) { [] }

    before { get(:index, :ids => ids) }

    subject(:api_ends) { json_to_ostruct(response.body) }

    its('endorses.count') { should eq(0) }

    context 'for existing endorses' do
      let(:ids) { [Fabricate(:endorse, :user => user).id] }

      its('endorses.count') { should eq(1) }
    end
  end

  describe '#show' do
    let(:end_id) { endorse.id }
    let(:endorse) { Fabricate(:endorse, :user => user) }

    context 'for an existing endorse' do
      before { get(:show, :id => end_id) }

      subject(:api_end) { json_to_ostruct(response.body, :endorse) }

      its('keys.size') { should eq(15) }
      its(:id) { should eq(endorse.id) }
      its(:slug) { should eq(endorse.slug) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(endorse.project.id) }
      its(:board_id) { should eq(endorse.board.id) }
      its(:comment_id) { should be_nil }
      its(:card_id) { should eq(endorse.card.id) }
      its(:topic_id) { should eq(endorse.topic.id) }
      its(:user_name) { should eq(user.nicename) }
      its(:project_title) { should_not be_nil }
      its(:board_title) { should_not be_nil }
      its(:topic_title) { should_not be_nil }
      its(:updated_at) { should_not be_blank }
      its(:last_update) { should eq(endorse.updated_at.to_s(:pretty)) }
    end

    context 'for a not owned endorse' do
      let(:endorse) { Fabricate(:endorse) }

      it 'raises not found' do
        expect{
          get(:show, :id => end_id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create' do
    let(:end_attrs) { Fabricate.attributes_for(:endorse, :user => user) }

    context 'attributes are valid' do
      before { post(:create, :endorse => end_attrs) }

      subject(:api_end) { json_to_ostruct(response.body, :endorse) }

      its('keys.count') { should eq(15) }
      its(:id) { should_not be_nil }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(end_attrs[:project_id]) }
      its(:board_id) { should eq(end_attrs[:board_id]) }
      its(:topic_id) { should eq(end_attrs[:topic_id]) }
      its(:card_id) { should eq(end_attrs[:card_id]) }

      context 'attributes are missing' do
        let(:end_attrs) {
          Fabricate.attributes_for(:endorse, :card => nil, :user => user) }

        subject(:api_end) { json_to_ostruct(response.body) }

        its('errors.count') { should_not eq(0) }
      end
    end

    context 'attributes are not valid' do
      let(:end_attrs) { Fabricate.attributes_for(:endorse) }

      it 'raises not found' do
        expect{
          post(:create, :endorse => end_attrs)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#destroy' do
    let(:endorse) { Fabricate(:endorse, :user => user) }
    let(:end_id) { endorse.id }

    before { delete(:destroy, :id => end_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'is not owned by current user' do
      let(:end_id) { Fabricate(:endorse) }

      its('response.status') { should eq(400) }
    end
  end
end
