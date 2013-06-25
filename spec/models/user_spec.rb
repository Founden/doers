require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:cards).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_inclusion_of(:interest).in_array(User::INTERESTS.values) }

  it 'sends a welcome email' do
    expect {
      Fabricate(:user)
    }.to change {
      SuckerPunch::Queue.new(:email).jobs.size
    }.by(1)
  end

  context 'unconfirmed' do
    subject { User.new }

    its(:confirmed?) { should be_false }
  end

  context 'instance' do
    subject { user }

    it { should be_valid }
    its('identities.first.uid') { should eq(user.email) }
    its(:email) { should_not be_empty }
    its(:name) { should_not be_empty }
    its(:nicename) { should eq(user.name) }
    its(:angel_list_id) { should eq(user.angel_list_id) }
    its(:interest) { should be_blank }
    its(:company) { should be_blank }
    its(:confirmed?) { should be_true }
    its(:admin?) { should be_false }
    its(:importing) { should be_false }

    context '#admin?' do
      before do
        user.update_attributes(:email => 'test@geekcelerator.com')
      end

      its(:admin?) { should be_true }
    end

    it 'sends a confirmation email' do
      expect {
        user.update_attributes(:confirmed => true)
      }.to change {
        SuckerPunch::Queue.new(:email).jobs.size
      }.by(1)
    end

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
