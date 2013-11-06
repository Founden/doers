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

  describe '#timing' do
    let(:timing) { 'never' }
    let(:notification_option) { 'notify_discussions' }
    let(:membership) do
      Membership.new(notification_option => timing)
    end

    subject { membership.timing(notification_option) }

    context 'when notification type is notify_discussions' do
      context 'when timing is set to now' do
        let(:timing) { 'now' }

        it { should eq(1) }
      end

      context 'when timing is set to asap' do
        let(:timing) { 'asap' }

        Timecop.freeze do
          its(:to_i) { should eq(
            (DateTime.now + Doers::Config.notifications.asap).to_i) }
        end
      end

      context 'when timing is set to daily' do
        let(:timing) { 'daily' }

        it { should eq(DateTime.now.at_end_of_day) }
      end

      context 'when timing is set to weekly' do
        let(:timing) { 'weekly' }

        it { should eq(DateTime.now.at_end_of_week) }
      end
    end

    context 'when notification type is notify_collaborations' do
      let(:notification_option) { 'notify_collaborations' }

      it { should be_false }
    end

    context 'when notification type is notify_cards_alignments' do
      let(:notification_option) { 'notify_cards_alignments' }

      it { should be_false }
    end

    context 'when notification type is notify_boards_topics' do
      let(:notification_option) { 'notify_boards_topics' }

      it { should be_false }
    end
  end
end
