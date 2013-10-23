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
    its('body.encoded') { should include(user.nicename) }
    its('body.encoded') { should include(project.title) }
    its(:to) { should include(user.email) }

    context 'with members' do
      let(:project) { Fabricate(:project_membership, :creator => user).project }

      it_should_behave_like 'an email from us'
      its('body.encoded') { should include(user.nicename) }
      its('body.encoded') { should include(project.title) }
      its('body.encoded') { should include(project.members.first.nicename) }
      its(:to) { should include(user.email) }
    end
  end

  context '#startup_import_failed' do
    before { UserMailer.startup_import_failed(user).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should include(user.nicename) }
    its(:to) { should include(user.email) }
  end

  context '#startup_exists' do
    let(:project) { Fabricate(:project) }

    before { UserMailer.startup_exists(project, user).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should include(user.nicename) }
    its('body.encoded') { should include(project.title) }
    its('body.encoded') { should include(project.user.nicename) }
    its(:to) { should include(user.email) }
  end

  context '#invitation_claimed' do
    let(:invitation) { Fabricate(:project_invitee) }
    let(:user) { User.find_by(:email => invitation.email) }

    before { UserMailer.invitation_claimed(invitation, user).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should include(invitation.user.nicename) }
    its('body.encoded') { should include(user.nicename) }
    its('body.encoded') { should include(invitation.invitable.title) }
    its(:to) { should include(invitation.user.email) }
  end

  context '#membership_notification' do
    let(:membership) { Fabricate(:project_membership) }

    before { UserMailer.membership_notification(membership).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should include(membership.creator.nicename) }
    its('body.encoded') { should include(membership.user.nicename) }
    its('body.encoded') { should include(membership.project.title) }
    its(:to) { should include(membership.user.email) }
  end

  context '#invite' do
    shared_examples 'an invitation from us' do
      its(:to) { should include(invitation.email) }
      its('body.encoded') { should include(user.nicename) }
      its('body.encoded') { should include(root_url) }
    end

    let(:invitation) { Fabricate(:invitation, :user => user) }

    before { UserMailer.invite(invitation).deliver }

    it_should_behave_like 'an email from us'
    it_should_behave_like 'an invitation from us'

    context 'to join a project' do
      let(:invitation) { Fabricate(:project_invitation, :user => user) }

      it_should_behave_like 'an invitation from us'
      its(:subject) { should include(invitation.invitable.title) }
      its('body.encoded') { should include(invitation.invitable.title) }
    end

    context 'to join a board' do
      let(:invitation) { Fabricate(:board_invitation, :user => user) }

      it_should_behave_like 'an invitation from us'
      its(:subject) { should include(invitation.invitable.title) }
      its('body.encoded') { should include(invitation.invitable.title) }
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
    its('body.encoded') { should include(user.nicename) }
    its('attachments') { should have(1).attachment }
    its('attachments.first.filename') { should eq('doers_boards.zip') }
    its(:to) { should include(user.email) }
  end
end
