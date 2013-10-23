require 'spec_helper'

describe Whiteboard do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
  it { should have_one(:cover).dependent(:destroy) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:topics).dependent('') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }

  context 'instance' do
    let(:whiteboard) { Fabricate(:whiteboard) }

    subject { whiteboard }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before do
        whiteboard.update_attributes(:title => content[0..250])
        whiteboard.update_attributes(:description => content)
      end

      its(:title) { should eq(Sanitize.clean(content[0..250])) }
      its(:description) { should eq(Sanitize.clean(content)) }
    end
  end
end
