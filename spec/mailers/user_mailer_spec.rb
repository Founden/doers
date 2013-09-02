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

  context '#confirmed' do
    before { UserMailer.confirmed(user).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(user.nicename) }
    its(:to) { should include(user.email) }
  end

  context '#startup_imported' do
    let(:project) { Fabricate(:project, :user => user) }

    before { UserMailer.startup_imported(project).deliver }

    it_should_behave_like 'an email from us'
    its('body.encoded') { should match(user.nicename) }
    its('body.encoded') { should match(project.title) }
    its(:to) { should include(user.email) }
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
end
