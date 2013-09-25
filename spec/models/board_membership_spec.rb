require 'spec_helper'
require 'board' # Fix the autoload shit

describe BoardMembership do
  it { should have_many(:activities).dependent('') }
  it { should have_many(:invitations).dependent('') }
  it { should validate_presence_of(:board) }

  context 'of an user to his own board' do
    let(:board) { Fabricate(:board) }
    subject(:membership) do
      Fabricate.build(
        :board_membership, :board => board, :user => board.author)
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

    subject { membership.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(membership.creator) }
      its('first.project') { should be_nil }
      its('first.board') { should eq(membership.board) }
      its('first.trackable') { should eq(membership) }
      its('first.trackable_type') { should eq(Membership.name) }
      its('first.trackable_title') { should eq(membership.user.nicename) }
      its('first.slug') { should eq('create-board-membership') }
    end

    context 'on update' do
      before { membership.update_attributes(:user => Fabricate(:user)) }

      its(:size) { should eq(1) }
    end

    context 'on delete' do
      before { membership.destroy }

      its(:size) { should eq(2) }
      its('last.user') { should eq(membership.creator) }
      its('first.project') { should be_nil }
      its('first.board') { should eq(membership.board) }
      its('first.trackable_id') { should eq(membership.id) }
      its('first.trackable_type') { should eq(Membership.name) }
      its('first.trackable_title') { should eq(membership.user.nicename) }
      its('last.slug') { should eq('destroy-board-membership') }
    end
  end
end
