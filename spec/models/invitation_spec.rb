require 'spec_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should belong_to(:membership) }
  it { should belong_to(:invitable) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  Invitation::ALLOWED_MEMBERSHIPS.each do |membership_type|
    it { should allow_value(membership_type).for(:membership_type) }
  end
  it { should_not allow_value(Faker::Lorem.word).for(:membership_type) }

  Invitation::ALLOWED_INVITABLES.each do |invitable_type|
    it { should allow_value(invitable_type).for(:invitable_type) }
  end
  it { should_not allow_value(Faker::Lorem.word).for(:invitable_type) }

  context 'when invitable is present and membership type is missing' do
    subject{ Fabricate.build(:project_invitation, :membership_type => '') }
    it { should_not be_valid }
  end

  context 'when membership type is present and invitable is missing' do
    subject do
      Fabricate.build(:invitation, :membership_type => BoardMembership.name)
    end
    it { should_not be_valid }
  end

  context 'instance' do
    subject(:invitation) { Fabricate(:invitation) }

    context '#claimer' do
      its(:claimer) { should be_blank }

      context 'when #email is registered' do
        let(:invitation) { Fabricate(:project_invitee) }

        its(:claimer) { should eq(invitation.membership.user) }
      end
    end

    context 'sends an email on creation', :use_truncation do
      before { UserMailer.should_receive(:invite) }
      subject { invitation }

      it { should be_valid }
    end

    context 'validations' do
      let(:invitable) { }
      let(:user) { Fabricate(:user) }

      subject(:invitation) {
        Fabricate.build(:invitation, :user => user, :invitable => invitable) }

      context 'invitable is not included in user projects' do
        let(:invitable) { Fabricate(:project) }
        it { should_not be_valid }

        context 'and when included' do
          let(:user) { invitable.user }
          it { should be_valid }
        end
      end

      context 'invitable is not included in user boards' do
        let(:invitable) { Fabricate(:board) }
        it { should_not be_valid }

        context 'and when included' do
          let(:user) { invitable.author }
          it { should be_valid }
        end
      end
    end

    context '#activities', :use_truncation do
      subject(:activities) { invitation.activity_owner.activities }

      context 'on create' do
        subject { activities.first }

        context 'when no invitable is set' do
          subject { activities.last }

          its(:user) { should eq(invitation.user) }
          its(:project) { should be_nil }
          its(:board) { should be_nil }
          its(:invitation_email) { should eq(invitation.email) }
          its(:slug) { should eq('create-invitation') }
        end

        context 'when invitable is a project' do
          its(:user) { should eq(invitation.user) }
          its(:project) { should eq(invitation.invitable) }
          its(:board) { should be_nil }
        end

        context 'when invitable is a board' do
          its(:user) { should eq(invitation.user) }
          its(:project) { should be_nil }
          its(:board) { should eq(invitation.invitable) }
        end
      end
    end
  end
end
