require 'spec_helper'
require 'project' # Fix the autoload shit

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
    let!(:membership) { Fabricate(:owner_membership) }

    subject(:emails) { ActionMailer::Base.deliveries }

    it { should be_empty }
  end
end
