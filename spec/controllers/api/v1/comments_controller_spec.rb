require 'spec_helper'

describe Api::V1::CommentsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:comment_ids) { [] }

    context 'when no comments are queries' do
      before { get(:index, :ids => comment_ids) }

      subject(:api_comments) { json_to_ostruct(response.body) }

      its(:comments) { should be_empty }
    end

    context 'for available comments' do
      let(:comment_ids) do
        3.times.collect{ Fabricate(:comment, :user => user).id }
      end

      before { get(:index, :ids => comment_ids) }
      subject(:api_comments) { json_to_ostruct(response.body) }

      its('comments.size') { should eq(user.comments.count) }
    end

    context 'for a not owned comments' do
      let(:comment_ids) { [Fabricate(:comment).id] }

      it 'raises 404' do
        expect{ get(:index, :ids => comment_ids) }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#show' do
    let(:comment) { Fabricate(:comment) }
    let(:comment_id) { comment.id }

    context 'for a not owned comment' do
      it 'raises not found' do
        expect{
          get(:show, :id => comment_id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for an owned comment' do
      let(:comment) do
        Fabricate(:topic_comment_with_parent_and_card, :user => user)
      end

      before { get(:show, :id => comment_id) }

      subject(:api_comment) { json_to_ostruct(response.body, :comment) }

      its('keys.size') { should eq(11) }
      its(:id) { should eq(comment.id) }
      its(:content) { should eq(comment.content) }
      its(:external_author_name) { should be_blank }
      its(:updated_at) { should_not be_blank }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(comment.project.id) }
      its(:board_id) { should eq(comment.board.id) }
      its(:parent_comment_id) { should eq(comment.parent_comment.id) }
      its(:comment_ids) { should be_empty }
      its(:card_id) { should eq(comment.card.id) }
      its(:topic_id) { should eq(comment.topic.id) }

      context 'when comment is a parent comment' do
        let(:comment_id) { comment.parent_comment.id }

        its('keys.size') { should eq(11) }
        its(:id) { should eq(comment.parent_comment.id) }
        its(:card_id) { should be_blank }
        its(:parent_comment_id) { should be_blank }
        its(:comment_ids) { should include(comment.id) }
      end
    end
  end

  describe '#create' do
    let(:comment_attrs) do
      Fabricate.attributes_for(
        :topic_comment_with_parent_and_card, :user => user)
    end
    let(:comment) { user.comments.first }

    before do
      post(:create, :comment => comment_attrs)
    end

    subject(:api_comment) { json_to_ostruct(response.body, :comment) }

    its('keys.size') { should eq(11) }
    its(:id) { should eq(comment.id) }
    its(:content) { should eq(comment.content) }
    its(:external_author_name) { should be_blank }
    its(:updated_at) { should_not be_blank }
    its(:user_id) { should eq(user.id) }
    its(:project_id) { should eq(comment.project.id) }
    its(:board_id) { should eq(comment.board.id) }
    its(:parent_comment_id) { should eq(comment.parent_comment.id) }
    its(:comment_ids) { should be_empty }
    its(:card_id) { should eq(comment.card.id) }
    its(:topic_id) { should be_blank }

    context 'when card is set' do
      let(:board) { Fabricate(:branched_board, :user => user) }
      let(:card) { Fabricate(
        :card, :board => board, :project => board.project) }
      let(:comment_attrs) { Fabricate.attributes_for(:comment, :board => board,
        :project => board.project, :user => user, :card_id => card.id) }

      subject(:api_comment) { json_to_ostruct(response.body, :comment) }

      its('keys.size') { should eq(11) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(comment.project.id) }
      its(:board_id) { should eq(comment.board.id) }
      its(:card_id) { should eq(card.id) }
    end
  end

  describe '#destroy' do
    let(:comment) { Fabricate(:comment) }
    let(:comment_id) { comment.id }

    before { delete(:destroy, :id => comment_id) }

    its('response.status') { should eq(400) }
    its('response.body') { should be_blank }

    context 'for an available comment' do
      let(:comment) { Fabricate(:comment, :user => user) }

      its('response.status') { should eq(204) }
      its('response.body') { should be_blank }
    end
  end
end
