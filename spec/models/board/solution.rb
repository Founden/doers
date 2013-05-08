require 'spec_helper'

describe Board::Solution do
  it { should validate_presence_of(:persona) }
end
