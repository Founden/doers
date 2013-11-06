require 'spec_helper'

describe NotificationsMailer, :use_truncation do
  require_relative 'shared'

  let(:membership) { Fabricate(:project_membership) }
  let(:project) { membership.project }
  let(:user) { membership.user }
  let(:comment) { Fabricate(
    :topic_comment_with_parent_and_card, :project => project, :user => user)}
  let(:invitation) { Fabricate(
    :project_invitation, :invitable => project, :user => project.user) }
  # This will generate a bunch of activities
  let(:activity) do
    invitation.destroy!
    project.memberships.create!(
      :creator => user, :user => Fabricate(:user)).destroy!
    comment.card.endorses.create!(:user => user, :project => project,
      :board => comment.board, :topic => comment.topic).destroy!
    comment.card.endorses.create!(:user => user, :project => project,
      :board => comment.board, :topic => comment.topic)
    project.save
    project.cards.each(&:save)
    project.topics.first.update_attributes(:activity_postfix => 'alignment')
    project.topics.first.update_attributes(:activity_postfix => 'misalignment')
    project.topics.each(&:save)
    project.boards.each(&:save)
    project.boards.each(&:destroy!)
    project.activities.reload.last
  end

  subject(:email) { ActionMailer::Base.deliveries.last }

  before(:each) { ActionMailer::Base.deliveries.clear }

  shared_examples 'a notification email' do
    its(:to) { should include(user.email) }
    its('body.encoded') { should include(user.nicename) }
    its('body.encoded') { should include(project.title) }
    its('body.encoded') do
      usernames.each { |username| should include(username) }
    end
  end

  context '#notify_discussions' do
    let(:slug_types) { %w(%comment% %endorse%) }
    let(:opts) { {'just_this' => false} }
    let(:usernames) do
      activity.search_for_project(user, slug_types).map(&:user_name).uniq
    end

    before do
      # Generate more activities
      NotificationsMailer.notify_discussions(
        membership, activity, opts).deliver
    end

    it_should_behave_like 'an email from us'
    it_should_behave_like 'a notification email'

    context 'when :just_this option is passed' do
      let(:opts) { {'just_this' => true} }

      its('body.encoded') { should include(activity.user_name) }
    end
  end

  context '#notify_collaborations' do
    let(:slug_types) { %w(%membership% %invitation%) }
    let(:opts) { {'just_this' => false} }
    let(:usernames) do
      activity.search_for_project(user, slug_types).map { |act|
        act.member_name || act.invitation_email
      }.uniq
    end

    before do
      # Generate more activities
      NotificationsMailer.notify_collaborations(
        membership, activity, opts).deliver
    end

    it_should_behave_like 'an email from us'
    it_should_behave_like 'a notification email'

    context 'when :just_this option is passed' do
      let(:opts) { {'just_this' => true} }

      its('body.encoded') { should include(activity.user_name) }
    end
  end

  context '#notify_boards_topics' do
    let(:slug_types) { %w(%board% %topic) }
    let(:opts) { {'just_this' => false} }
    let(:usernames) do
      activity.search_for_project(user, slug_types).map(&:user_name).uniq
    end

    before do
      # Generate more activities
      NotificationsMailer.notify_boards_topics(
        membership, activity, opts).deliver
    end

    it_should_behave_like 'an email from us'
    it_should_behave_like 'a notification email'

    context 'when :just_this option is passed' do
      let(:opts) { {'just_this' => true} }

      its('body.encoded') { should include(activity.user_name) }
    end
  end

  context '#notify_cards_alignments' do
    let(:slug_types) { %w(%card% %alignment%) }
    let(:opts) { {'just_this' => false} }
    let(:usernames) do
      activity.search_for_project(user, slug_types).map(&:user_name).uniq
    end

    before do
      # Generate more activities
      NotificationsMailer.notify_cards_alignments(
        membership, activity, opts).deliver
    end

    it_should_behave_like 'an email from us'
    it_should_behave_like 'a notification email'

    context 'when :just_this option is passed' do
      let(:opts) { {'just_this' => true} }

      its('body.encoded') { should include(activity.user_name) }
    end
  end
end
