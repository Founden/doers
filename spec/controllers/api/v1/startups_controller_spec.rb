require 'spec_helper'

describe Api::V1::StartupsController do
  let(:user) { Fabricate(:user) }

  before do
    ImportJob.stub_chain(:new, :perform)
    controller.stub(:current_account) { user }
  end

  describe '#create' do
    let(:startup) do
      startup = MultiJson.load(
        Rails.root.join('spec/fixtures/angel_list_startups.json')
      )['startup_roles'].first['startup']
      startup['angel_list_id'] = startup['id']
      startup
    end

    before do
      post(:create, :startup => startup)
    end

    context 'when user has no imports' do
      its('response.response_code') { should eq(200) }
    end

    context 'when user has an import going' do
      let(:user) { Fabricate(:user, :importing => true) }

      its('response.response_code') { should eq(403) }
    end
  end

end
