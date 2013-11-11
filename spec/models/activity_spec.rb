require 'spec_helper'

describe Activity, :use_truncation do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:whiteboard) }
  it { should belong_to(:project) }
  it { should belong_to(:card) }
  it { should belong_to(:comment) }
  it { should belong_to(:topic) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:slug) }

  context 'caches name' do
    let(:user) { Fabricate(:user) }
    let!(:trackable) { user }

    subject { trackable.activities.first }

    context 'for the user' do
      its(:user_name) { should eq(user.nicename) }
    end

    context 'for the project' do
      let(:project) { Fabricate(:project, :user => user) }
      let(:trackable) { project }

      its(:user_name) { should eq(user.nicename) }
      its(:project) { should eq(project) }
      its(:project_title) { should eq(project.title) }
    end

    context 'for the board' do
      let(:board) { Fabricate(:board, :user => user) }
      let(:trackable) { board }
      subject { trackable.activities.last }

      its(:user_name) { should eq(user.nicename) }
      its(:board) { should eq(board) }
      its(:board_title) { should eq(board.title) }
    end

    context 'for the card' do
      let(:card) { Fabricate(:card, :user => user) }
      let(:trackable) { card }

      its(:user_name) { should eq(user.nicename) }
      its(:card) { should eq(card) }
      its(:card_title) { should eq(card.title) }
    end

    context 'for the topic' do
      let(:topic) { Fabricate(:topic, :user => user) }
      let(:trackable) { topic }

      its(:user_name) { should eq(user.nicename) }
      its(:topic) { should eq(topic) }
      its(:topic_title) { should eq(topic.title) }
    end
  end

  context '#activity_slug' do
    subject(:project) { Fabricate(:project) }
    let(:title) { Faker::Lorem.sentence }
    let(:slug) { Faker::Lorem.word }

    before do
      project.update_attributes(
        :title => title, :activity_postfix => slug)
    end

    its(:title) { should eq(title) }
    its('activities.first.slug') { should include(slug) }
  end

  context '#activity_author' do
    subject(:project) { Fabricate(:project) }
    let(:some_user) { Fabricate(:user) }
    let(:title) { Faker::Lorem.sentence }

    before do
      project.update_attributes(
        :title => title, :activity_author => some_user)
    end

    its(:title) { should eq(title) }
    its('activities.first.user') { should eq(some_user) }
  end

  context '#remove_previous_if_same_as' do
    subject(:project) { Fabricate(:project) }

    its('activities.count') { should eq(1) }

    context 'after calling save' do
      before { project.save }

      its('activities.count') { should eq(2) }
    end

    context 'after calling #save multiple times' do
      before { rand(2..5).times{ project.save } }

      its('activities.count') { should eq(2) }
    end

    context "after #save in < #{Doers::Config.activity_remove_at} minutes" do
      before do
        project.save
        freeze_at = Time.current + Doers::Config.activity_remove_at - 1.minute
        Timecop.freeze(freeze_at) do
          project.save
        end
      end

      its('activities.count') { should eq(2) }
    end

    context "after #save after #{Doers::Config.activity_remove_at} minutes" do
      before do
        freeze_at = Time.current + Doers::Config.activity_remove_at + 1.minute

        project.save
        Timecop.freeze(freeze_at) do
          project.save
        end
      end

      its('activities.count') { should eq(3) }
    end
  end

  context 'order defaults to Activity#updated_at' do
    let!(:activities) { Fabricate(:board).user.activities }
    let(:dates) { activities.pluck('updated_at').map(&:to_i) }

    context '#all' do
      subject do
        activities.order(:updated_at => :desc).pluck('updated_at').map(&:to_i)
      end

      it { should eq(dates) }
      it { should eq(dates.sort.reverse) }
    end
  end

  context '#search_for_project' do
    let(:user) { Fabricate(:user) }
    let(:activity) { user.activities.last }
    let(:slug_types) { ['%'] }
    let(:user_to_ignore) { user }

    subject { activity.search_for_project(user_to_ignore, slug_types) }

    it { should be_nil }

    context 'when activity has a project' do
      let(:project) { Fabricate(:project, :user => user) }
      let(:activity) { project.activities.first }

      its(:count) { should eq(0) }

      context 'for other user' do
        let(:user_to_ignore) { Fabricate(:user) }

        its(:count) { should eq(1) }
      end
    end

    context 'when activity has a project with users activity' do
      let(:project) { Fabricate(:project_membership, :user => user).project }
      let(:board) { Fabricate(:board, :project => project, :user => user) }
      let(:activity) { board.project.activities.last }
      let(:user_to_ignore) { project.user }

      its(:count) { should eq(5) }

      it { should_not include(activity) }

      context 'when slug type is set for board only' do
        let(:slug_types) { ['%board%'] }

        its(:count) { should eq(1) }
      end
    end
  end

  describe '#notify_project_collaborators' do
    let(:membership) { }

    subject(:project) { membership.project }

    context 'when project has no collaborators' do
      let(:membership) { Fabricate(:project).collaborations.first }

      before do
        Activity.any_instance.should_not_receive(:notify_project_collaborator)
      end

      it { should be_valid }
    end

    context 'project has collaborators notifications disabled' do
      let(:membership) do
        Fabricate(:project_membership, :notify_collaborations => 'never')
      end

      before do
        Activity.any_instance.should_not_receive(:notify_project_collaborator)
      end

      it { should be_valid }
    end

    context 'project collaborator is ignored if is activity user' do
      let(:membership) do
        Fabricate(:project_membership)
      end

      before do
        Activity.any_instance.should_receive(:notify_project_collaborator).once
      end

      it { should be_valid }
    end
  end

  describe '#notify_project_collaborator' do
    let(:queue_type) { 'notify_collaborations' }
    let(:timing_option) { 'asap' }
    let(:activity) { membership.project.activities.last }
    let(:membership) do
      Fabricate(:project_membership, queue_type => timing_option)
    end

    subject do
      activity.stub(:queue_type) { queue_type }
      activity.send(:notify_project_collaborator, membership)
    end
    before(:all) do
      Delayed::Worker.delay_jobs = true
      Timecop.freeze
    end
    after(:all) do
      Delayed::Worker.delay_jobs = false
      Timecop.return
    end

    context 'when notification option is set to now' do
      let(:timing_option) { 'now' }

      its(:class) { should eq(Delayed::Job) }
      its(:queue) { should eq(queue_type) }
      its('run_at.to_i') { should eq(DateTime.current.to_i) }
      its(:membership_id) { should eq(membership.id) }

      context 'for a specific notification option' do
        let(:queue_type) { 'notify_boards_topics' }

        its(:queue) { should eq(queue_type) }
      end
    end

    context 'when collaborator already has no job scheduled' do
      before { membership.delayed_jobs.delete_all }

      its(:class) { should eq(Delayed::Job) }
      its(:queue) { should eq(queue_type) }
      its(:membership_id) { should eq(membership.id) }
      its('run_at.to_i') { should eq(DateTime.current.advance(
        :seconds => Doers::Config.notifications.asap).to_i) }
    end

    context 'when collaborator has a job scheduled' do
      let(:timing_option) { 'daily' }

      its(:class) { should eq(Delayed::Job) }
      its(:queue) { should eq(queue_type) }
      its('run_at.to_i') { should eq(DateTime.current.at_end_of_day.to_i) }
      its(:membership_id) { should eq(membership.id) }

      context 'if timing option is set to weekly' do
        let(:timing_option) { 'weekly' }

        its('run_at.to_i') { should eq(DateTime.current.at_end_of_week.to_i) }
      end
    end

    context 'when collaborator has a job scheduled and it needs rescheduling' do
      let(:timing_option) { 'asap' }
      let(:new_member) { Fabricate(:project_membership,
        :creator => membership.creator, :project => membership.project) }

      before do
        Timecop.freeze(Time.current + Doers::Config.notifications.offset * 2) do
          new_member
        end
      end

      its(:class) { should eq(Delayed::Job) }
      its(:queue) { should eq(queue_type) }
      its(:membership_id) { should eq(membership.id) }
      its('run_at.to_i') { should eq(DateTime.current.advance(
        :seconds => Doers::Config.notifications.asap).to_i) }
    end
  end

  describe '#queue_type' do
    subject { activity.send(:queue_type) }

    context 'for a comment' do
      let(:activity) { Activity.new(:slug => '-comment-') }

      it { should eq('notify_discussions') }
    end

    context 'for an endorse' do
      let(:activity) { Activity.new(:slug => '-endorse-') }

      it { should eq('notify_discussions') }
    end

    context 'for a membership' do
      let(:activity) { Activity.new(:slug => '-membership-') }

      it { should eq('notify_collaborations') }
    end

    context 'for an invitation' do
      let(:activity) { Activity.new(:slug => '-invitation-') }

      it { should eq('notify_collaborations') }
    end

    context 'for a card' do
      let(:activity) { Activity.new(:slug => '-card-') }

      it { should eq('notify_cards_alignments') }
    end

    context 'for an alignment' do
      let(:activity) { Activity.new(:slug => '-alignment-') }

      it { should eq('notify_cards_alignments') }
    end

    context 'for a board' do
      let(:activity) { Activity.new(:slug => '-board-') }

      it { should eq('notify_boards_topics') }
    end

    context 'for a topic' do
      let(:activity) { Activity.new(:slug => '-topic-') }

      it { should eq('notify_boards_topics') }
    end
  end
end
