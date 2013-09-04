require 'spec_helper'

describe Api::V1::MembershipsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:memb_ids) { [] }
    before { get(:index, :ids => memb_ids) }

    subject(:api_memberships) { json_to_ostruct(response.body) }

    its(:memberships) { should be_empty }

    context 'for owned memberships' do
      let(:memb_ids) do
        3.times.collect{ Fabricate(:project_membership, :user => user).id }
      end

      its('memberships.size') { should eq(user.memberships.count) }
    end

    context 'for not owned memberships' do
      let(:memb_ids) do
        3.times.collect{ Fabricate(:project_membership).id }
      end

      its(:memberships) { should be_empty }
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

      its('keys.size') { should eq(6) }
      its(:id) { should eq(memb.id) }
      its(:user_id) { should eq(user.id) }
      its(:creator_id) { should eq(memb.creator.id) }
      its(:project_id) { should eq(memb.project.id) }
      its(:board_id) { should be_nil }
      its(:updated_at) { should_not be_blank }

      context 'of board' do
        let(:memb) { Fabricate(:board_membership, :user => user) }

        its('keys.size') { should eq(6) }
        its(:project_id) { should be_nil }
        its(:board_id) { should eq(memb.board.id) }
      end

    end
  end

  describe '#destroy' do
    # let(:invite) { Fabricate(:invitation) }
    # let(:invite_id) { invite.id }

    # before { delete(:destroy, :id => invite_id) }

    # its('response.status') { should eq(400) }
    # its('response.body') { should be_blank }

    # context 'for an available invite' do
    #   let(:invite) { Fabricate('invitation', :user => user) }
    #   let(:invite_id) { invite.id }

    #   its('response.status') { should eq(204) }
    #   its('response.body') { should be_blank }
    # end
  end
end
