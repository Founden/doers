require 'spec_helper'

describe Api::V1::StartupsController do
  let(:user) { Fabricate(:user) }

  before do
    ImportJob.stub_chain(:new, :perform)
    controller.stub(:current_account) { user }
  end

  describe '#index' do

    before { get(:index) }

    its('response.body') { should be_blank }
    its('response.status') { should eq(200) }
  end

  describe '#create' do
    let(:startup) do
      json = File.read Rails.root.join('spec/fixtures/angel_list_startups.json')
      startup = json_to_ostruct(json)['startup_roles'].first['startup']
      startup['external_id'] = startup['id']
      startup
    end

    before do
      post(:create, :startup => startup)
    end

    context 'when user has no imports' do
      its('response.status') { should eq(200) }

      context '#importing' do
        subject { user.importing }

        it { should be_true }
      end
    end

    context 'when user has an import going' do
      let(:user) { Fabricate(:user, :importing => true) }

      its('response.status') { should eq(200) }
    end

    context 'when a project like that exists' do
      let(:user) do
        Fabricate(:imported_project, :external_id => startup['id']).user
      end

      its('response.status') { should eq(400) }
    end
  end

end
