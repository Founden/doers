require 'spec_helper'

describe Board::Persona do
  it { should have_one(:problem) }
  it { should have_one(:solution) }
end
