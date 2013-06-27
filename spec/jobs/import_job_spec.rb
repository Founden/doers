require 'spec_helper'

describe ImportJob do
  let(:user) { Fabricate(:user, :importing => true) }
  let(:startup_id) { rand(10..20) }
  let(:access_token) { user.identities.first.token }
  let(:import) { ImportJob.new(user, startup_id) }

  context '#perform' do
    before do
      import.should_receive(:import_project).and_return(false)
      UserMailer.should_receive(:startup_imported).exactly(0).times
      import.perform
    end

    subject { import }

    its(:user) { should eq(user) }
    its(:startup_id) { should eq(startup_id) }
    its(:access_token) { should eq(access_token) }
    its(:startup_url) { should match(startup_id.to_s) }
    its(:startup_url) { should match(access_token) }
    its(:startup_comments_url) { should match(startup_id.to_s) }
    its(:startup_comments_url) { should match(access_token) }
  end

  context '#perform on success sends an email and flags importing as false' do
    let(:project) { Fabricate(:project, :user => user) }
    before do
      import.should_receive(:import_project).and_return(project)
      import.should_receive(:import_project_comments)
      UserMailer.should_receive(:startup_imported).and_call_original
      import.project = project
      import.perform
    end

    subject { import }

    its('user.importing') { should be_false }
  end

  context '#process_json' do
    let(:json) { ['a', 'b', 'c'].to_json }

    before do
      stub_request(:get, import.startup_url).to_return(:body => json)
    end

    subject(:data) { import.process_json(import.startup_url) }

    its(:first) { should eq('a') }
    its(:size) { should eq(3) }
  end

  context '#import_project' do
    let(:startup) do
      MultiJson.load(
        Rails.root.join('spec/fixtures/angel_list_startups.json')
      )['startup_roles'].first['startup']
    end

    before do
      import.should_receive(:process_json).and_return(startup)
      import.import_project
    end

    subject(:project) { import.project }

    its(:angel_list_id) { should eq(startup['id']) }
    its(:title) { should eq(startup['name']) }
    its(:description) { should eq(startup['high_concept']) }
    its(:website) { should eq(startup['company_url']) }
    its(:logo) { should_not be_nil }
  end

  context '#import_project_comments' do
    let(:project) { Fabricate(:project) }
    let(:data) do
      MultiJson.load(
        Rails.root.join('spec/fixtures/angel_list_startup_comments.json'))
    end

    before do
      import.should_receive(:process_json).and_return(data)
      import.project = project
      import.import_project_comments
    end

    subject(:comments) { import.project.comments }

    its(:count) { should eq(data.count) }
    its('first.author.nicename') { should eq(data.first['user']['name']) }
    its('first.author.email') { should match(data.first['user']['id'].to_s) }
  end
end
