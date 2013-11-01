require 'spec_helper'

describe Api::V1::MembershipsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:memb_ids) { [] }

    subject(:api_memberships) { json_to_ostruct(response.body) }

    context 'when nothing is queried' do
      before { get(:index, :ids => memb_ids) }

      its(:memberships) { should be_empty }
    end

    context 'for created memberships' do
      let(:memb_ids) do
        3.times.collect{ Fabricate(:project_membership, :creator => user).id }
      end

      before { get(:index, :ids => memb_ids) }

      its('memberships.size') { should eq(3) }
    end

    context 'for owned memberships' do
      let(:memb_ids) do
        3.times.collect{ Fabricate(:project_membership, :user => user).id }
      end

      before { get(:index, :ids => memb_ids) }

      its('memberships.size') { should eq(user.memberships.count) }
    end

    context 'for not owned memberships' do
      let(:memb_ids) do
        3.times.collect{ Fabricate(:project_membership).id }
      end

      it 'raises not found' do
        expect{
          get(:index, :ids => memb_ids)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#show' do
    let(:memb) { Fabricate(:project_membership) }
    let(:memb_id) { memb.id }

    context 'for a not owned membership' do
      it 'raises not found' do
        expect{
          get(:show, :id => memb_id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for an owned membership' do
      let(:memb) { Fabricate(:project_membership, :user => user) }

      before { get(:show, :id => memb_id) }

      subject(:api_membership) { json_to_ostruct(response.body, :membership) }

      its('keys.size') { should eq(10) }
      its(:id) { should eq(memb.id) }
      its(:user_id) { should eq(user.id) }
      its(:creator_id) { should eq(memb.creator.id) }
      its(:project_id) { should eq(memb.project.id) }
      its(:board_id) { should be_nil }
      its(:updated_at) { should_not be_blank }
      its(:notify_discussions) { should eq(Membership::TIMING.first) }
      its(:notify_collaborations) { should eq(Membership::TIMING.first) }
      its(:notify_boards_topics) { should eq(Membership::TIMING.first) }
      its(:notify_cards_alignments) { should eq(Membership::TIMING.first) }

      context 'when is not owned' do
        let(:memb) { Fabricate(:project_membership, :creator => user) }

        its('keys.size') { should eq(6) }
      end

      context 'of board' do
        let(:memb) { Fabricate(:board_membership, :user => user) }

        its('keys.size') { should eq(10) }
        its(:project_id) { should be_nil }
        its(:board_id) { should eq(memb.board.id) }
      end

    end
  end

  describe '#update' do
    let(:memb) { Fabricate(:project_membership) }
    let(:memb_id) { memb.id }
    let(:attrs) { }

    context 'for a not owned membership' do
      it 'raises not found' do
        expect{
          put(:update, :id => memb_id, :membership => attrs)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for an owned membership' do
      let(:memb) { Fabricate(:project_membership, :user => user) }
      let(:attrs) do
        { :notify_discussions => Membership::TIMING.sample,
          :notify_collaborations => Membership::TIMING.sample,
          :notify_boards_topics => Membership::TIMING.sample,
          :notify_cards_alignments => Membership::TIMING.sample,
          :user_id => memb.creator.id
        }
      end

      before { put(:update, :id => memb_id, :membership => attrs) }

      subject(:api_membership) { json_to_ostruct(response.body, :membership) }

      its('keys.size') { should eq(10) }
      its(:id) { should eq(memb.id) }
      its(:user_id) { should eq(user.id) }
      its(:creator_id) { should eq(memb.creator.id) }
      its(:project_id) { should eq(memb.project.id) }
      its(:board_id) { should be_nil }
      its(:updated_at) { should_not be_blank }
      its(:notify_discussions) { should eq(attrs[:notify_discussions]) }
      its(:notify_collaborations) { should eq(attrs[:notify_collaborations]) }
      its(:notify_boards_topics) { should eq(attrs[:notify_boards_topics]) }
      its(:notify_cards_alignments){ should eq(attrs[:notify_cards_alignments])}

      context 'with an invalid param' do
        let(:attrs) { {:notify_discussions => Faker::Lorem.word} }

        subject(:api_membership) { json_to_ostruct(response.body) }

        its(:errors) { should_not be_empty }
      end
    end
  end

  describe '#destroy' do
    let(:membership) { Fabricate(:project_membership) }
    let(:memb_id) { membership.id }

    before { delete(:destroy, :id => memb_id) }

    its('response.status') { should eq(400) }
    its('response.body') { should be_blank }

    context 'for an available membership' do
      let(:membership) { Fabricate(:project_membership, :user => user) }

      its('response.status') { should eq(204) }
      its('response.body') { should be_blank }
    end
  end
end
