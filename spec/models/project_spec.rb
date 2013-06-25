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

  context 'instance' do
    subject { project }

    its(:status) { should eq(Project::STATES.first) }
    its(:angel_list_id) { should be_nil }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before do
        project.update_attributes(:title => content)
        project.update_attributes(:description => content)
      end

      its(:title) { should eq(Sanitize.clean(content)) }
      its(:description) { should eq(Sanitize.clean(content)) }
    end
  end
end
