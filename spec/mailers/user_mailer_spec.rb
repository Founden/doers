require 'spec_helper'

describe UserMailer do
  let(:user) { Fabricate(:user) }

  subject(:email) { ActionMailer::Base.deliveries.last }

  before(:each) { ActionMailer::Base.deliveries.clear }

  # TODO: Move this to a more general purpose file
  shared_examples 'an email from us' do
    its(:subject) { should include(Doers::Config.app_name) }
    its(:from) { should include(
      Mail::Address.new(Doers::Config.default_email).address) }
    its(:return_path) { should include(
      Mail::Address.new(Doers::Config.contact_email).address) }
  end

  context '#startup_imported' do
    let(:project) { Fabricate(:project, :user => user) }

    before { UserMailer.startup_imported(project).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(user.nicename) }
    its('body.encoded') { should match(project.title) }
    its(:to) { should include(user.email) }
  end

  context '#invitation_claimed' do
    let(:invitation) { Fabricate(:project_invitee) }
    let(:user) { User.find_by(:email => invitation.email) }

    before { UserMailer.invitation_claimed(invitation, user).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(invitation.user.nicename) }
    its('body.encoded') { should match(user.nicename) }
    its('body.encoded') { should match(invitation.invitable.title) }
    its(:to) { should include(invitation.user.email) }
  end

  context '#membership_notification' do
    let(:membership) { Fabricate(:project_membership) }

    before { UserMailer.membership_notification(membership).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(membership.creator.nicename) }
    its('body.encoded') { should match(membership.user.nicename) }
    its('body.encoded') { should match(membership.project.title) }
    its(:to) { should include(membership.user.email) }
  end

  context '#invite' do
    shared_examples 'an invitation from us' do
      its(:to) { should include(invitation.email) }
      its('body.encoded') { should match(user.nicename) }
      its('body.encoded') { should match(root_url) }
    end

    let(:invitation) { Fabricate(:invitation, :user => user) }

    before { UserMailer.invite(invitation).deliver }

    it_should_behave_like 'an email from us'
    it_should_behave_like 'an invitation from us'

    context 'to join a project' do
      let(:invitation) { Fabricate(:project_invitation, :user => user) }

      it_should_behave_like 'an invitation from us'
      its(:subject) { should match(invitation.invitable.title) }
      its('body.encoded') { should match(invitation.invitable.title) }
    end

    context 'to join a board' do
      let(:invitation) { Fabricate(:board_invitation, :user => user) }

      it_should_behave_like 'an invitation from us'
      its(:subject) { should match(invitation.invitable.title) }
      its('body.encoded') { should match(invitation.invitable.title) }
    end
  end

  context '#export_data' do
    let(:user) { Fabricate(:user) }
    let(:zip_path) { File.expand_path(user.id.to_s + '.zip', Dir.tmpdir) }

    before do
      File.write(zip_path, rand(100))
      UserMailer.export_data(user, zip_path).deliver
    end
    after { File.unlink(zip_path) }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(user.nicename) }
    its('attachments') { should have(1).attachment }
    its('attachments.first.filename') { should eq('doers_boards.zip') }
    its(:to) { should include(user.email) }
  end
end
