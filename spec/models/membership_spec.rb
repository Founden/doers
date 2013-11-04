require 'spec_helper'

describe Membership do
  it { should belong_to(:user) }
  it { should belong_to(:creator) }
  it { should belong_to(:project) }
  it { should belong_to(:board) }
  it { should belong_to(:whiteboard) }
  it { should have_one(:invitation) }
  it { should validate_presence_of(:creator) }
  it { should validate_presence_of(:user) }
  it { should have_many(:delayed_jobs).dependent(:destroy) }

  Membership::TIMING.values.each do |timing|
    it { should allow_value(timing).for(:notify_discussions) }
    it { should allow_value(timing).for(:notify_collaborations) }
    it { should allow_value(timing).for(:notify_boards_topics) }
    it { should allow_value(timing).for(:notify_cards_alignments) }
  end

  Faker::Lorem.word.tap do |wrong_timing|
    it { should_not allow_value(wrong_timing).for(:notify_discussions) }
    it { should_not allow_value(wrong_timing).for(:notify_collaborations) }
    it { should_not allow_value(wrong_timing).for(:notify_boards_topics) }
    it { should_not allow_value(wrong_timing).for(:notify_cards_alignments) }
  end

  context 'instance' do
    subject { Membership.new }

    its(:notify_discussions) { should eq(Membership::TIMING.values.first) }
    its(:notify_collaborations) { should eq(Membership::TIMING.values.first) }
    its(:notify_boards_topics) { should eq(Membership::TIMING.values.first) }
    its(:notify_cards_alignments) { should eq(Membership::TIMING.values.first) }
  end

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
