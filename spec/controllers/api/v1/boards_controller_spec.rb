require 'spec_helper'

describe Api::V1::BoardsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:board_ids) { [] }

    subject(:api_boards) { json_to_ostruct(response.body) }

    context 'when no boards are queried' do
      before { get(:index, :ids => board_ids) }

      its('boards.size') { should eq(0) }
    end

    context 'for a not owned board' do
      let(:board_ids) { [Fabricate(:board).id] }

      it 'raises 404' do
        expect{ get(:index, :ids => board_ids) }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end

    context 'when queried ids are available' do
      let(:boards) { Fabricate(:project_with_boards, :user => user).boards }
      let(:board_ids) { boards.map(&:id) }

      before { get(:index, :ids => board_ids) }

      its('boards.size') { should_not eq(0) }
      its('boards.size') { should eq(boards.count) }
    end
  end

  describe '#show' do
    context 'for available boards' do
      let(:board) { Fabricate(:board, :user => user) }
      let(:board_id) { board.id }

      before { get(:show, :id => board_id) }

      subject(:api_board) { json_to_ostruct(response.body, :board) }

      its('keys.size') { should eq(14) }
      its(:id) { should eq(board.id) }
      its(:title) { should eq(board.title) }
      its(:status) { should eq(Board::STATES.first) }
      its(:updated_at) { should_not be_nil }
      its(:description) { should eq(board.description) }
      its(:user_id) { should eq(board.user.id) }
      its(:cover_id) { should be_blank }
      its(:project_id) { should eq(board.project_id) }
      its(:whiteboard_id) { should be_blank }
      its(:topic_ids) { should eq(board.topic_ids) }
      its(:topics_count) { should eq(board.topics.count) }
      its('activity_ids.size') { should eq(board.activities.count) }
      its('membership_ids.size') { should eq(board.memberships.count) }
      its(:progress) { should eq(0) }
    end

    it 'raises an error for a private board ' do
      expect { get(:show, :id => Fabricate(:board)) }.to raise_error
    end

    it 'raises an error for a missing board ' do
      expect { get(:show, :id => Faker::Lorem.word) }.to raise_error
    end
  end

  describe '#create' do
    let(:project) { Fabricate(:project, :user => user) }
    let(:title) { Faker::Lorem.sentence }
    let(:attrs) { Fabricate.attributes_for(:board,
      :project => project, :user => user, :title=>title) }

    context 'when project is available' do
      before { post(:create, :board => attrs) }

      subject(:api_board) { json_to_ostruct(response.body, :board) }

      its('keys.size') { should eq(14) }
      its(:title) { should eq(title) }
      its(:description) { should eq(attrs[:description]) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(project.id) }
      its(:progress) { should eq(100) }

      context 'when title is not set' do
        let(:title) { nil }

        subject { json_to_ostruct(response.body) }

        its('errors.count') { should_not eq(0) }
        it 'gives status 400' do
          response.status.should eq(400)
        end
      end
    end

    context 'when project is not accessible' do
      let(:project) { Fabricate(:project) }

      it 'raises not found' do
        expect{ post(:create, :board => attrs) }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#update' do
    let(:board) { Fabricate(:board, :user => user) }
    let(:board_attrs) { Fabricate.attributes_for(:board) }
    let(:board_id) { board.id }

    before { patch(:update, :board => board_attrs, :id => board_id) }

    subject(:api_board) { json_to_ostruct(response.body, :board) }

    its('keys.size') { should eq(14) }
    its(:title) { should eq(board_attrs['title']) }
    its(:description) { should eq(board_attrs['description']) }
    its(:user_id) { should eq(user.id) }
    its(:project_id) { should eq(board.project.id) }
    its(:progress) { should eq(0) }

    context 'ignores wrong attributes' do
      let(:board_attrs) { Fabricate.attributes_for(:board) }

      its('keys.size') { should eq(14) }
      its(:title) { should eq(board_attrs['title']) }
      its(:description) { should eq(board_attrs['description']) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(board.project.id) }
      its(:whiteboard_id) { should eq(board.whiteboard_id) }
      its(:status) { should eq(board.status) }
    end

    it 'does nothing to a not owned board' do
      expect {
        patch(:update, :board => board_attrs, :id => Fabricate(:board).id)
      }.to raise_error
    end
  end

  describe '#destroy' do
    let(:board) { Fabricate(:board, :user => user) }
    let(:board_id) { board.id }

    before { delete(:destroy, :id => board_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'board is not owned by current user' do
      let(:board_id) { rand(999..9999) }

      its('response.status') { should eq(400) }
    end
  end

end
