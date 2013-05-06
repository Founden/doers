require 'spec_helper'

describe Api::V1::ProjectsController do
  let(:user) { Fabricate(:user) }

  before do
    2.times { Fabricate(:project, :user => user) }
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before { get(:index) }

    it 'serializes current user projects list into a json' do
      projects = JSON.parse(response.body)['projects']
      projects.count.should eq(2)
    end
  end

  describe '#show' do
    before { get(:show, :id => user.id) }

    it 'serializes user project into a json' do
      api_project = JSON.parse(response.body)['project']
      api_project.keys.count.should eq(6)

      project = user.projects.first

      api_project['id'].should eq(project.id)
      api_project['title'].should eq(project.title)
      api_project['description'].should eq(project.description)
      api_project['status'].should eq(project.status)
      api_project['updated_at'].should_not be_blank
      api_project['user']['id'].should eq(user.id)
    end
  end
end
