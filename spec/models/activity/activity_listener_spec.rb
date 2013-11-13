require 'spec_helper'

describe Activity::Notifier do
  let(:user) { Fabricate(:user) }

  describe '#on_notifications' do
    let(:queries) { [] }

    before do
      user.class.connection.stub(:execute) { |query| queries << query }
      user.should_receive(:before_listen)
      user.should_receive(:after_listen)
      user.should_receive(:handle_notifications).and_yield(nil)
      user.stub(:loop).and_yield
    end
    after do
      user.class.connection.unstub(:execute)
      queries.each do |query|
        user.class.connection.execute(query)
      end
    end

    it 'will make calls to LISTEN and UNLISTEN' do
      expect { |blk| user.on_notifications(&blk) }.to yield_with_args(nil)
      queries.should include('LISTEN %s' % user.send(:channel))
      queries.should include('UNLISTEN %s' % user.send(:channel))
    end
  end

  describe '#handle_notifications' do
    let(:payload) { [user.class.name, user.id].join(',') }

    before do
      user.class.connection.raw_connection.should_receive(:wait_for_notify).
        and_yield(nil, nil, payload).and_return(nil)
    end

    specify do
      expect { |blk| user.send(:handle_notifications, &blk) }.to yield_control
    end
  end

  describe '#channel' do
    subject { user.send(:channel) }

    it { should eq('user_%d' % user.id) }
  end

  describe '#parse_payload' do
    let(:payload) { Faker::Lorem.sentence }

    subject { user.send(:parse_payload, payload) }

    context 'when payload object exists' do
      let(:activity) { Fabricate(:activity) }
      let(:payload) { [activity.class.name, activity.id].join(',') }

      it { should eq(activity) }
    end

    context 'when payload object does not exist' do
      it { should be_nil }
    end
  end

end
