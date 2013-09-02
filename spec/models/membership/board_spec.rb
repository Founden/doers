require 'spec_helper'

describe Membership::Board do
  it { should have_many(:invitations) }
  it { should validate_presence_of(:board) }

  context 'of an user to his own board' do
    let(:board) { Fabricate(:board, :user => user) }
    let(:membership) do
      Fabricate.attributes_for(
        'membership/board', :board => project, :user => user)
    end

    it { should_not be_valid }
  end

  context '#activities', :use_truncation do
    let(:membership) { Fabricate('membership/board') }

    subject { membership.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(membership.creator) }
      its('first.project') { should be_nil }
      its('first.board') { should eq(membership.board) }
      its('first.trackable') { should eq(membership) }
      its('first.trackable_type') { should eq(Membership.name) }
      its('first.trackable_title') { should eq(membership.user.nicename) }
      its('first.slug') { should eq('create-membership-board') }
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
      its('last.slug') { should eq('destroy-membership-board') }
    end
  end
end
