require 'spec_helper'
require 'membership'

describe OwnerMembership do
  it { should validate_presence_of(:project) }

  context 'of an user to his own project' do
    let(:project) { Fabricate(:project) }
    subject(:membership) do
      Fabricate.build(
        :owner_membership, :project => project, :user => Fabricate(:user))
    end

    its(:project) { should eq(project) }
    it { should_not be_valid }
  end

  context '#notify_member should not trigger' do
    subject(:membership) { Fabricate(:owner_membership) }

    before do
      OwnerMembership.any_instance.should_not receive(:notify_member)
    end

    it { should be_valid }
  end
end
