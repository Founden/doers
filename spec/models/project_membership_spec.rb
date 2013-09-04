require 'spec_helper'

describe ProjectMembership do
  it { should have_many(:activities).dependent('') }
  it { should have_many(:invitations).dependent('') }
  it { should validate_presence_of(:project) }

  context 'of an user to his own project' do
    let(:project) { Fabricate(:project) }
    subject(:membership) do
      Fabricate.build(
        :project_membership, :project => project, :user => project.user)
    end

    it { should_not be_valid }
  end

  context '#activities', :use_truncation do
    let(:membership) { Fabricate(:project_membership) }

    subject { membership.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(membership.creator) }
      its('first.project') { should eq(membership.project) }
      its('first.board') { should be_nil }
      its('first.trackable') { should eq(membership) }
      its('first.trackable_type') { should eq(Membership.name) }
      its('first.trackable_title') { should eq(membership.user.nicename) }
      its('first.slug') { should eq('create-project-membership') }
    end

    context 'on update' do
      before { membership.update_attributes(:user => Fabricate(:user)) }

      its(:size) { should eq(1) }
    end

    context 'on delete' do
      before { membership.destroy }

      its(:size) { should eq(2) }
      its('last.user') { should eq(membership.creator) }
      its('last.project') { should eq(membership.project) }
      its('last.board') { should be_nil }
      its('last.trackable_id') { should eq(membership.id) }
      its('last.trackable_type') { should eq(Membership.name) }
      its('last.trackable_title') { should eq(membership.user.nicename) }
      its('last.slug') { should eq('destroy-project-membership') }
    end
  end
end
