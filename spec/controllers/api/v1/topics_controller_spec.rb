require 'spec_helper'

describe Api::V1::TopicsController do
  let(:user) { Fabricate(:user) }
  let(:board) { Fabricate(:board, :author => user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:topic_ids) { [] }

    subject(:api_topic) { json_to_ostruct(response.body) }

    context 'when no topics are queried' do
      before { get(:index, :ids => topic_ids) }

      its('topics.size') { should eq(0) }
    end

    context 'when queried ids are available' do
      let(:topic_ids) { [Fabricate(:topic, :board => board).id] }
      before { get(:index, :ids => topic_ids) }

      its('topics.size') { should eq(1) }
    end

    context 'when queried ids are not available' do
      let(:topic_ids) { [Fabricate(:topic).id] }

      it 'raises 404' do
        expect{ get(:index, :ids => topic_ids) }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#show' do
    let(:topic_id) { rand(99..999) }

    it 'wont find unavailable topic' do
      expect {
        get(:show, :id => topic_id)
      }.to raise_error
    end

    context 'for available topic' do
      let(:topic) {
        Fabricate(:topic, :board => board) }
      let(:topic_id) { topic.id }

      before { get(:show, :id => topic_id) }

      subject(:api_topic) { json_to_ostruct(response.body, :topic) }

      its(:id) { should eq(topic.id) }
      its(:title) { should eq(topic.title) }
      its(:description) { should eq(topic.description) }
      its(:position) { should eq(topic.position) }
      its(:updated_at) { should_not be_nil }
      its(:user_id) { should eq(topic.user.id) }
      its(:board_id) { should eq(topic.board.id) }
      its('activity_ids.size') { should eq(topic.activities.count) }
      its('comment_ids.size') { should eq(topic.comments.count) }
    end
  end

  describe '#create' do
    let(:topic_attrs) {}

    context 'with wrong parameters' do
      context 'on title' do
        let(:topic_attrs) {
          Fabricate.attributes_for(:topic, :user => user, :title => '') }

        before { post(:create, :topic => topic_attrs) }

        its('response.status') { should eq(400) }
        its('response.body') { should match('errors') }
      end

      context 'on board' do
        let(:topic_attrs) {
          Fabricate.attributes_for(:topic, :user => user, :board => nil) }

        it 'raises not found' do
          expect{ post(:create, :topic => topic_attrs) }.to raise_error(
            ActiveRecord::RecordNotFound)
        end
      end

      context 'on a not owned board' do
        let(:topic_attrs) do
          Fabricate.attributes_for(
            :topic, :user => user, :board => Fabricate(:board))
        end

        it 'raises not found' do
          expect{ post(:create, :topic => topic_attrs) }.to raise_error(
            ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'with valid parameters' do
      let(:topic_attrs) {
        Fabricate.attributes_for(:topic, :user => user, :board => board) }

      before { post(:create, :topic => topic_attrs) }

      subject(:api_topic) { json_to_ostruct(response.body, :topic) }

      its('keys.size')   { should eq(10) }
      its(:id)           { should_not be_blank }
      its(:title)        { should eq(topic_attrs[:title]) }
      its(:description)  { should eq(topic_attrs[:description]) }
      its(:position)     { should_not be_nil }
      its(:updated_at)   { should_not be_blank }
      its(:user_id)      { should eq(user.id) }
      its(:board_id)     { should eq(board.id) }
      its(:activity_ids) { should be_empty }
      its(:comment_ids)  { should be_empty }
    end
  end

  describe '#update' do
    let(:topic_attrs) { Fabricate.attributes_for(:topic) }
    let(:topic_id) { rand(99..999) }

    it 'does nothing to a not owned topic' do
      expect {
        patch(:update, :topic => {:title => ''}, :id => topic_id)
      }.to raise_error
    end

    context 'for available topic' do
      let(:topic) { Fabricate(:topic, :board => board, :user => user) }
      let(:topic_id) { topic.id }

      before { patch(:update, :id => topic_id, :topic => topic_attrs) }

      subject(:api_topic) { json_to_ostruct(response.body, :topic) }

      its('keys.size')   { should eq(10) }
      its(:title)        { should eq(topic_attrs[:title]) }
      its(:description)  { should eq(topic_attrs[:description]) }
      its(:position)     { should_not be_nil }
      its(:updated_at)   { should_not be_blank }
      its(:user_id)      { should eq(user.id) }
      its(:board_id)     { should eq(board.id) }
      its(:activity_ids) { should be_empty }
      its(:comment_ids)  { should be_empty }
    end
  end

  describe '#destroy' do
    let(:topic) do
      Fabricate(:topic, :board => board)
    end
    let(:topic_id) { topic.id }

    before { delete(:destroy, :id => topic_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'topic is not owned by current user' do
      let(:topic_id) { rand(999...9999) }

      its('response.status') { should eq(400) }
    end
  end
end
