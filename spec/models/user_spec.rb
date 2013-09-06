require 'spec_helper'

describe User do
  it { should have_many(:created_projects).dependent(:destroy) }
  it { should have_many(:shared_projects).through(:accepted_memberships) }
  it { should have_many(:branched_boards).dependent('') }
  it { should have_many(:authored_boards).dependent('') }
  it { should have_many(:shared_boards).through(:accepted_memberships) }
  it { should have_many(:cards).dependent('') }
  it { should have_many(:comments) }
  it { should have_many(:assets) }
  it { should have_many(:images).dependent('') }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:created_memberships).dependent(:destroy) }
  it { should have_many(:accepted_memberships).dependent(:destroy) }
  it { should have_many(:invitations).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_inclusion_of(:interest).in_array(User::INTERESTS.values) }

  context 'unconfirmed' do
    subject { User.new }

    its(:confirmed?) { should be_false }
  end

  context 'instance' do
    subject(:user) { Fabricate(:user) }

    it { should be_valid }
    its('identities.first.uid') { should eq(user.email) }
    its(:email) { should_not be_empty }
    its(:name) { should_not be_empty }
    its(:nicename) { should eq(user.name) }
    its(:external_id) { should eq(user.external_id) }
    its(:interest) { should be_blank }
    its(:company) { should be_blank }
    its(:confirmed?) { should be_true }
    its(:admin?) { should be_false }
    its(:importing) { should be_false }

    context '#projects' do
      let(:project) { Fabricate(:project, :user => user) }

      its(:projects) { should include(project) }
    end

    context '#boards' do
      let(:board) { Fabricate(:board, :user => user) }

      its(:boards) { should include(board) }
    end

    context '#memberships' do
      let(:membership) { Fabricate(:project_membership, :user => user) }

      its(:memberships) { should include(membership) }
    end

    context '#newsletter_allowed?' do
      its(:newsletter_allowed?) { should be_true }

      context 'when user opted against it' do
        before do
          user.update_attributes(:newsletter_allowed => false)
        end

        its(:newsletter_allowed?) { should be_false }
      end
    end

    context '#admin?' do
      before do
        user.update_attributes(:email => 'test@geekcelerator.com')
      end

      its(:admin?) { should be_true }
    end

    context '#claim_invitation' do
      let!(:invite) { Fabricate(:project_invitation, :email => user.email) }

      its(:claim_invitation) { should eq(invite) }

      context 'creates the membership' do
        before { user.claim_invitation }

        its(:shared_projects) { should include(invite.invitable) }
      end
    end

    context 'sends a confirmation email', :use_truncation do
      before do
        UserMailer.should_receive(:confirmed)
      end

      it { user.update_attributes(:confirmed => '1') }
    end

    context '#nicename when #name is blank' do
      before { user.update_attribute(:name, nil) }

      its(:nicename) { should eq(user.email) }
    end

    context 'on duplicates' do
      subject { Fabricate.build(:user, :email => user.email) }

      it { should_not be_valid }
    end
  end

  context '#before_create', :use_truncation do
    let(:user) { Fabricate.build(:user) }
    let!(:invitation) { Fabricate(:invitation, :email => user.email) }

    it 'sends an email to inviter' do
      UserMailer.should_receive(:invitation_claimed).and_call_original
      user.save
      user.email.should eq(invitation.email)
    end
  end
end
