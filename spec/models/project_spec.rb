require 'spec_helper'

describe Project do
  let(:project) { Fabricate(:project) }

  it { should belong_to(:user) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:cards).through(:boards).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:logo).dependent(:destroy) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }

  it { should allow_value(Faker::Internet.uri(:http)).for(:website) }
  it { should allow_value(Faker::Internet.uri(:https)).for(:website) }
  it { should_not allow_value(Faker::Internet.domain_name).for(:website) }

  it { should ensure_inclusion_of(:status).in_array(Project::STATES) }
  it { should ensure_inclusion_of(
    :external_type).in_array(Doers::Config.external_types) }

  context 'instance' do
    subject { project }

    its(:status) { should eq(Project::STATES.first) }

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
