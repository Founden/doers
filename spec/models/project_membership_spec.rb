require 'spec_helper'
require 'project' # Fix the autoload shit

describe ProjectMembership do
  it { should validate_presence_of(:project) }

  context 'of an user to his own project' do
    let(:project) { Fabricate(:project) }
    subject(:membership) do
      Fabricate.build(
        :project_membership, :project => project, :user => project.user)
    end

    it { should_not be_valid }
  end

  context '#notify_member', :use_truncation do
    let!(:membership) { Fabricate(:project_membership) }

    subject(:email) { ActionMailer::Base.deliveries.last }

    its(:to) { should include(membership.user.email) }
  end

  context '#activities', :use_truncation do
    let(:membership) { Fabricate(:project_membership) }

    subject(:activities) { membership.activity_owner.activities }

    context 'on create' do
      subject { activities.first }

      its(:user) { should eq(membership.creator) }
      its(:project) { should eq(membership.project) }
      its(:board) { should be_nil }
      its(:slug) { should eq('create-project-membership') }
    end

    context 'on update' do
      before { membership.update_attributes(:user => Fabricate(:user)) }

      subject { activities.collect(&:slug) }

      it { should_not include('update-project-membership') }
    end

    context 'on delete' do
      before { membership.destroy }

      subject { activities.first }

      its(:user) { should eq(membership.creator) }
      its(:project) { should eq(membership.project) }
      its(:board) { should be_nil }
      its(:slug) { should eq('destroy-project-membership') }
    end
  end
end
