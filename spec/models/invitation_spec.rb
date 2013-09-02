require 'spec_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should belong_to(:membership) }
  it { should belong_to(:invitable) }
  it { should have_many(:activities) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should allow_value('Membership::Project').for(:membership_type) }
  it { should allow_value('Membership::Board').for(:membership_type) }
  it { should_not allow_value(Faker::Lorem.word).for(:membership_type) }

  it { should allow_value('Project').for(:invitable_type) }
  it { should allow_value('Board').for(:invitable_type) }
  it { should_not allow_value(Faker::Lorem.word).for(:invitable_type) }

  context 'when invitable is present and membership type is missing' do
    subject{ Fabricate.build(:project_invitation, :membership => nil) }
    it { should_not be_valid }
  end

  context 'when membership type is present and invitable is missing' do
    subject do
      Fabricate.build(:invitation, :membership_type => Membership::Board.name)
    end
    it { should_not be_valid }
  end

  context 'instance' do
    let(:invitation) { Fabricate(:invitation) }

    context 'sends an email on creation', :use_truncation do
      before { UserMailer.should_receive(:invite) }
      subject { invitation }

      it { should be_valid }
    end

    context '#activities', :use_truncation do
      subject { invitation.activities }

      context 'on create' do
        its(:size) { should eq(1) }
        its('first.user') { should eq(invitation.user) }
        its('first.project') { should be_nil }
        its('first.board') { should be_nil }
        its('first.trackable') { should eq(invitation) }
        its('first.trackable_type') { should eq(Invitation.name) }
        its('first.trackable_title') { should eq(invitation.email) }
        its('first.slug') { should eq('create-invitation') }

        context 'when invitable is a project' do
          its(:size) { should eq(1) }
          its('first.user') { should eq(invitation.user) }
          its('first.project') { should eq(invitation.invitable) }
          its('first.board') { should be_nil }
        end

        context 'when invitable is a board' do
          its(:size) { should eq(1) }
          its('first.user') { should eq(invitation.user) }
          its('first.project') { should be_nil }
          its('first.board') { should eq(invitation.invitable) }
        end
      end
    end
  end
end
