require 'spec_helper'
require 'whiteboard' # Fix the autoload shit

describe WhiteboardMembership do
  it { should validate_presence_of(:whiteboard) }

  context 'of an user to his own whiteboard' do
    let(:whiteboard) { Fabricate(:whiteboard) }
    subject(:membership) do
      Fabricate.build(:whiteboard_membership,
                      :whiteboard => whiteboard, :user => whiteboard.user)
    end

    it { should_not be_valid }
  end

  context '#notify_member', :use_truncation do
    let!(:membership) { Fabricate(:whiteboard_membership) }

    subject(:email) { ActionMailer::Base.deliveries.last }

    its(:to) { should include(membership.user.email) }
  end

  context '#activities', :use_truncation do
    let(:membership) { Fabricate(:whiteboard_membership) }

    subject(:activities) { membership.activity_owner.activities }

    context 'on create' do
      subject { activities.last }

      its(:user) { should eq(membership.creator) }
      its(:project) { should be_nil }
      its(:whiteboard) { should eq(membership.whiteboard) }
      its(:slug) { should eq('create-whiteboard-membership') }
    end

    context 'on update' do
      before { membership.update_attributes(:user => Fabricate(:user)) }

      subject { activities.collect(&:slug) }

      it { should_not include('update-whiteboard-membership') }
    end

    context 'on delete' do
      before { membership.destroy }

      subject { activities.last }

      its(:user) { should eq(membership.creator) }
      its(:project) { should be_nil }
      its(:whiteboard) { should eq(membership.whiteboard) }
      its(:slug) { should eq('destroy-whiteboard-membership') }
    end
  end
end
