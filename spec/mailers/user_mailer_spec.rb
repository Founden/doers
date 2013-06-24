require 'spec_helper'

describe UserMailer do
  let(:user) { Fabricate(:user) }
  subject(:email) { ActionMailer::Base.deliveries.first }

  before(:each) { ActionMailer::Base.deliveries.clear }

  # TODO: Move this to a more general purpose file
  shared_examples 'an email from us' do
    its(:subject) { should include(Doers::Config.app_name) }
    its(:to) { should include(user.email) }
    its(:from) { should include(Doers::Config.default_email) }
    its(:return_path) { should include(Doers::Config.contact_email) }
  end

  context '#welcome' do
    before { UserMailer.welcome(user).deliver }

    it_should_behave_like 'an email from us'
    its(:body) { should match(user.nicename) }
  end

  context '#confirmed' do
    before { UserMailer.confirmed(user).deliver }

    it_should_behave_like 'an email from us'
    its(:body) { should match(user.nicename) }
  end

  context '#startup_imported' do
    let(:project) { Fabricate(:project, :user => user) }

    before { UserMailer.startup_imported(project).deliver }

    it_should_behave_like 'an email from us'
    its(:body) { should match(user.nicename) }
    its(:body) { should match(project.title) }
  end
end
