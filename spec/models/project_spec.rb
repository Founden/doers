require 'spec_helper'

describe Project do
  it { should belong_to(:user) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:cards).through(:boards).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:logo).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:owner_memberships).dependent(:destroy) }
  it { should have_many(:members).through(:memberships) }
  it { should have_many(:owners).through(:owner_memberships) }
  it { should have_many(:invitations).dependent(:destroy) }
  it { should have_many(:topics).dependent('') }
  it { should have_many(:collaborators).through(:collaborations) }
  it { should have_many(:collaborations).dependent('') }
  it { should have_many(:endorses).dependent(:destroy) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }

  it { should allow_value(Faker::Internet.uri(:http)).for(:website) }
  it { should allow_value(Faker::Internet.uri(:https)).for(:website) }
  it { should_not allow_value(Faker::Internet.domain_name).for(:website) }
  it { should ensure_inclusion_of(:status).in_array(Project::STATES) }
  it { should allow_value(nil).for(:external_id) }

  context 'instance' do
    subject(:project) { Fabricate(:project) }

    its(:status) { should eq(Project::STATES.first) }
    its(:owners) { should include(project.user) }

    context 'when imported' do
      subject(:project) { Fabricate(:imported_project) }

      it { should ensure_inclusion_of(
        :external_type).in_array(Doers::Config.external_types) }
      it { should validate_uniqueness_of(
        :external_id).scoped_to(:external_type, :user_id) }
    end

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before do
        project.update_attributes(:title => content[0..250])
        project.update_attributes(:description => content)
      end

      its(:title) { should eq(Sanitize.clean(content[0..250])) }
      its(:description) { should eq(Sanitize.clean(content)) }
    end
  end
end
