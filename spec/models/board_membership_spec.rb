require 'spec_helper'
require 'board' # Fix the autoload shit

describe BoardMembership do
  it { should validate_presence_of(:board) }

  context 'of an user to his own board' do
    let(:board) { Fabricate(:board) }
    subject(:membership) do
      Fabricate.build(:board_membership, :board => board, :user => board.user)
    end

    it { should_not be_valid }
  end

  context '#notify_member', :use_truncation do
    let!(:membership) { Fabricate(:board_membership) }

    subject(:email) { ActionMailer::Base.deliveries.last }

    its(:to) { should include(membership.user.email) }
  end

  context '#activities', :use_truncation do
    let(:membership) { Fabricate(:board_membership) }

    subject(:activities) { membership.activity_owner.activities }

    context 'on create' do
      subject { activities.first }

      its(:user) { should eq(membership.creator) }
      its(:project) { should be_nil }
      its(:board) { should eq(membership.board) }
      its(:slug) { should eq('create-board-membership') }
    end

    context 'on update' do
      before { membership.update_attributes(:user => Fabricate(:user)) }

      subject { activities.collect(&:slug) }

      it { should_not include('update-board-membership') }
    end

    context 'on delete' do
      before { membership.destroy }

      subject { activities.first }

      its(:user) { should eq(membership.creator) }
      its(:project) { should be_nil }
      its(:board) { should eq(membership.board) }
      its(:slug) { should eq('destroy-board-membership') }
    end
  end
end
