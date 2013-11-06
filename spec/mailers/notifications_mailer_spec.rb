require 'spec_helper'
require_relative 'shared'

describe NotificationsMailer, :use_truncation do
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

  context '#notify_boards_topics' do
    let(:slug_types) { %w(%board% %topic) }
    let(:opts) { {'just_this' => false} }

    before do
      # Generate more activities
      NotificationsMailer.notify_boards_topics(
        membership, activity, opts).deliver
    end

    it_should_behave_like 'an email from us'
    its(:to) { should include(user.email) }
    its('body.encoded') { should include(user.nicename) }
    its('body.encoded') { should include(project.title) }
    its('body.encoded') { should include(activity.followed_for_project(
      slug_types).map(&:user_name).uniq.join(', ')) }
  end
end
