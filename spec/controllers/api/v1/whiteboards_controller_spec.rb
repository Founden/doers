require 'spec_helper'

describe Api::V1::WhiteboardsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  context '#index' do
    let(:whiteboard_ids) { [] }

    subject(:api_whiteboards) { json_to_ostruct(response.body) }

    before { get(:index, :ids => whiteboard_ids) }

    context 'when no whiteboards are queried' do
      its('whiteboards.size') { should eq(0) }
    end

    context 'when a whiteboard is not owned' do
      let(:whiteboard_ids) { [Fabricate(:whiteboard).id] }

      its('whiteboards.size') { should eq(1) }
    end

    context 'when whiteboards are available' do
      let(:whiteboard_ids) {
        2.times.collect { Fabricate(:whiteboard, :user => user).id } }

      its('whiteboards.size') { should eq(2) }
    end
  end

  context '#show' do
    let(:whiteboard) { Fabricate(:whiteboard) }
    let(:whiteboard_id) { whiteboard.id }

    before { get(:show, :id => whiteboard_id) }
    subject(:api_whiteboard) { json_to_ostruct(response.body, :whiteboard) }

    its('keys.size') { should eq(11) }
    its(:id) { should eq(whiteboard.id) }
    its(:title) { should eq(whiteboard.title) }
    its(:description) { should eq(whiteboard.description) }
    its('collections.size') { should eq(whiteboard.tags.count) }
    its(:topics_count) { should eq(whiteboard.topics.count) }
    its(:user_id) { should eq(whiteboard.user.id) }
    its(:team_id) { should eq(whiteboard.team_id) }
    its(:cover_id) { should eq(whiteboard.cover.id) }
    its('topic_ids.size') { should eq(whiteboard.topics.count) }
    its('boards_count') { should eq(whiteboard.boards.count) }
    its('activity_ids.size') { should eq(whiteboard.activities.count) }
  end

  context '#create' do
    let(:attrs) { Fabricate.attributes_for(:whiteboard) }

    subject(:api_whiteboard) { json_to_ostruct(response.body, :whiteboard) }

    context 'when params are valid' do
      before { post(:create, :whiteboard => attrs) }

      its('keys.size') { should eq(11) }
      its(:id) { should_not be_blank }
      its(:title) { should eq(attrs[:title]) }
      its(:description) { should eq(attrs[:description]) }
      its(:topics_count) { should eq(0) }
      its(:activity_ids) { should_not be_empty }
      its(:user_id) { should eq(user.id) }
      its(:boards_count) { should eq(0) }
    end

    context 'when board ID is set'  do
      let(:board) { Fabricate(:board, :user => user) }

      before { post(:create, :whiteboard => attrs.merge(:board_id => board.id))}

      its('keys.size') { should eq(11) }
      its(:id) { should_not be_blank }
      its(:title) { should eq(board.title) }
      its(:description) { should eq(board.description) }
      its(:topics_count) { should eq(board.topics.count) }
      its(:activity_ids) { should_not be_empty }
      its(:boards_count) { should eq(1) }
      its(:user_id) { should eq(user.id) }

      context 'board whiteboard' do
        subject { board.reload }

        its(:whiteboard_id) { should_not be_blank }
      end
    end

    context 'when board ID is set and unavailable' do
      let(:board) { Fabricate(:board) }

      it 'gives 404' do
        expect {
          post(:create, :whiteboard => attrs.merge(:board_id => board.id))
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when params are not valid' do
      before { post(:create, :whiteboard => attrs.except(:title)) }

      subject(:api_whiteboard) { json_to_ostruct(response.body) }

      its('errors') { should_not be_empty }
    end

  end

  context '#update' do
    let(:whiteboard_id) { whiteboard.id }
    let(:attrs) { Fabricate.attributes_for(:whiteboard) }

    subject(:api_whiteboard) { json_to_ostruct(response.body, :whiteboard) }

    context 'when whiteboard is available' do
      let(:whiteboard) { Fabricate(:whiteboard, :user => user) }

      before { patch(:update, :id => whiteboard_id, :whiteboard => attrs) }

      its('keys.size') { should eq(11) }
      its(:id) { should eq(whiteboard.id) }
      its(:title) { should eq(attrs[:title]) }
      its(:description) { should eq(attrs[:description]) }
      its(:user_id) { should eq(whiteboard.user.id) }
    end

    context 'when whiteboard is not available' do
      let(:whiteboard) { Fabricate(:whiteboard) }

      it 'gives 404' do
        expect{
          patch(:update, :id => whiteboard_id, :whiteboard => attrs)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  context '#destroy' do
    let(:whiteboard) { Fabricate(:whiteboard, :user => user) }
    let(:whiteboard_id) { whiteboard.id }

    before { delete(:destroy, :id => whiteboard_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'board is not owned by current user' do
      let(:whiteboard_id) { rand(999..9999) }

      its('response.status') { should eq(400) }
    end
  end

end
