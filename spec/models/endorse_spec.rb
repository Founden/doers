require 'spec_helper'

describe Endorse do
  context 'instance' do
    let(:endorse) { Fabricate(:endorse) }

    subject { endorse }

    its(:slug) { should eq('create-endorse') }
    its(:type) { should eq(Endorse.name) }
  end
end
