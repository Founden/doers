require 'spec_helper'

describe EmailWorker do
  let(:user) { Fabricate(:user) }

  context '#perform' do
    before { UserMailer.any_instance.should_receive(:welcome).once }

    it 'delivers an email' do
      EmailWorker.new.perform(:welcome, user.id)
    end
  end
end
