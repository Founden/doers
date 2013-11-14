require 'spec_helper'

describe Api::V1::UpdatesController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    it 'raises Tubesock error' do
      expect {
        get(:index)
      }.to raise_error(Tubesock::HijackNotAvailable)
    end
  end
end
