require 'spec_helper'

describe Board::Problem do
  it { should validate_presence_of(:persona) }
end
