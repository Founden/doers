require 'spec_helper'

describe Activity do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should belong_to(:trackable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:trackable_id) }
  it { should validate_presence_of(:trackable_type) }
  it { should validate_presence_of(:slug) }
end
