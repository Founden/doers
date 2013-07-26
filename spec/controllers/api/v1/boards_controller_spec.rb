require 'spec_helper'

describe Api::V1::BoardsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:board_ids) { [] }
    let(:status) { }

    before do
      get(:index, :ids => board_ids, :status => status)
    end

    subject(:api_boards) { json_to_ostruct(response.body) }

    its('boards.size') { should eq(0) }

    context 'for a not owned board' do
      let(:board_ids) { [Fabricate(:branched_board).id] }

      its('boards.size') { should eq(0) }

      context 'when queried public boards' do
        let(:status) { Board::STATES.last }

        its('boards.size') { should eq(1) }
      end

      context 'when queried private boards' do
        let(:status) { Board::STATES.first }

        its('boards.size') { should eq(0) }
      end
    end

    context 'when queried ids are available' do
      let(:boards) { Fabricate(:project_with_boards, :user => user).boards }
      let(:board_ids) { boards.map(&:id) }

      its('boards.size') { should_not eq(0) }
      its('boards.size') { should eq(boards.count) }

      context 'when queried public boards' do
        let(:status) { 'public' }

        its('boards.size') { should eq(3) }
      end

      context 'when queried private boards' do
        let(:status) { 'private' }

        its('boards.size') { should eq(boards.count) }
      end
    end
  end

  describe '#show' do
    context 'for available boards' do
      let(:board) { Fabricate(:branched_board, :user => user) }
      let(:board_id) { board.id }

      before { get(:show, :id => board_id) }

      subject(:api_board) { json_to_ostruct(response.body, :board) }

      its('keys.size') { should eq(14) }
      its(:id) { should eq(board.id) }
      its(:title) { should eq(board.title) }
      its(:status) { should eq(Board::STATES.first) }
      its(:updated_at) { should_not be_nil }
      its(:description) { should eq(board.description) }
      its(:last_update) { should eq(board.updated_at.to_s(:pretty)) }
      its(:author_nicename) { should be_nil }
      its(:user_nicename) { should eq(board.user.nicename) }
      its(:user_id) { should eq(board.user.id) }
      its(:author_id) { should be_nil }
      its(:project_id) { should eq(board.project.id) }
      its(:parent_board_id) { should eq(board.parent_board.id) }
      its(:branch_ids) { should be_empty }
      its(:card_ids) { should be_empty }

      context 'for #parent_board' do
        let(:board_id) { board.parent_board.id }

        its('keys.size') { should eq(14) }

        its(:author_nicename) { should eq(board.parent_board.author.nicename) }
        its(:user_nicename) { should be_nil }
        its(:user_id) { should be_nil }
        its(:author_id) { should eq(board.parent_board.author.id) }
        its(:project_id) { should be_nil }
        its(:parent_board_id) { should be_nil }
      end
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
    let(:board_attrs) { Fabricate.attributes_for(
        :branched_board, :project => project, :user => user) }

    before { post(:create, :board => board_attrs) }

    subject(:api_board) { json_to_ostruct(response.body, :board) }

    its('keys.size') { should eq(14) }
    its(:title) { should eq(board_attrs['title']) }
    its(:description) { should eq(board_attrs['description']) }
    its(:user_id) { should eq(user.id) }
    its(:project_id) { should eq(project.id) }
    its(:parent_board_id) { should eq(board_attrs['parent_board_id']) }

    context 'ignores wrong attributes' do
      pending
    end

    context 'on missing attributes' do
      subject(:api_board) { json_to_ostruct(response.body) }

      context 'like project' do
        let(:project) {}

        its('errors.size') { should eq(1) }
      end
    end
  end

  describe '#update' do
    let(:board) { Fabricate(:branched_board, :user => user) }
    let(:board_attrs) { Fabricate.attributes_for(:board) }
    let(:board_id) { board.id }

    before { patch(:update, :board => board_attrs, :id => board_id) }

    subject(:api_board) { json_to_ostruct(response.body, :board) }

    its('keys.size') { should eq(14) }
    its(:title) { should eq(board_attrs['title']) }
    its(:description) { should eq(board_attrs['description']) }
    its(:user_id) { should eq(user.id) }
    its(:project_id) { should eq(board.project.id) }
    its(:parent_board_id) { should eq(board.parent_board.id) }

    context 'ignores wrong attributes' do
      let(:board_attrs) { Fabricate.attributes_for(:branched_board) }

      its('keys.size') { should eq(14) }
      its(:title) { should eq(board_attrs['title']) }
      its(:description) { should eq(board_attrs['description']) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(board.project.id) }
      its(:parent_board_id) { should eq(board.parent_board.id) }
      its(:status) { should eq(board.status) }
    end

    it 'does nothing to a not owned board' do
      expect {
        patch(:update, :board => board_attrs, :id => board.parent_board.id)
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
