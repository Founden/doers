require 'spec_helper'

describe Membership do
  it { should belong_to(:user) }
  it { should belong_to(:creator) }
  it { should have_many(:activities).dependent('') }
  it { should validate_presence_of(:creator) }
  it { should validate_presence_of(:user) }
end
