require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:panels).dependent('') }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:fields).dependent('') }

  it { should have_many(:oauth_applications).dependent(:destroy) }
  it { should have_many(:access_tokens).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  context 'instance' do
    subject { user }

    it { should be_valid }
    its('identities.first.uid') { should eq(user.email) }
    its(:email) { should_not be_empty }
    its(:name) { should_not be_empty }
    its(:nicename) { should eq(user.name) }
    its(:access_tokens) { should be_empty }

    context '#nicename when #name is blank' do
      before { user.update_attribute(:name, nil) }

      its(:nicename) { should eq(user.email) }
    end

    context 'on duplicates' do
      subject { Fabricate.build(:user, :email => user.email) }

      it { should_not be_valid }
    end
  end
end
