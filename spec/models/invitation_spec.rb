require 'spec_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should belong_to(:membership) }
  it { should belong_to(:invitable) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should allow_value('Membership::Project').for(:membership_type) }
  it { should allow_value('Membership::Board').for(:membership_type) }
  it { should_not allow_value(Faker::Lorem.word).for(:membership_type) }

  it { should allow_value('Project').for(:invitable_type) }
  it { should allow_value('Board').for(:invitable_type) }
  it { should_not allow_value(Faker::Lorem.word).for(:invitable_type) }

  context 'when invitable is present and membership type is missing' do
    subject{ Fabricate.build(:project_invitation, :membership => nil) }
    it { should_not be_valid }
  end

  context 'when membership type is present and invitable is missing' do
    subject do
      Fabricate.build(:invitation, :membership_type => Membership::Board.name)
    end
    it { should_not be_valid }
  end
end
