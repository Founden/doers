require 'spec_helper'

describe Membership do
  it { should belong_to(:user) }
  it { should belong_to(:creator) }
  it { should belong_to(:project) }
  it { should belong_to(:board) }
  it { should have_one(:invitation) }
  it { should validate_presence_of(:creator) }
  it { should validate_presence_of(:user) }

  context 'invitation' do
    subject(:membership) do
      Fabricate(:project_invitee).membership
    end

    its(:invitation) { should_not be_nil }

    it 'on destroy' do
      membership.destroy
      expect{
        membership.invitation.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
