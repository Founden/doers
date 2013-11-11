require 'spec_helper'

describe Activity::Notifier do
  let(:activity) { Fabricate(:activity) }
  let(:payload) do
    [activity.class.name, activity.id].join(',')
  end

  describe '#notify_channels' do
    let(:channel) { 'user_id' }
    let(:queries) { [] }

    before do
      activity.class.connection.stub(:execute) { |query| queries << query }
      activity.should_receive(:channels).and_return([channel])
    end
    after do
      activity.class.connection.unstub(:execute)
      queries.each do |query|
        activity.class.connection.execute(query)
      end
    end

    it 'triggers a notify query' do
      activity.send(:notify_channels)
      queries.should include("NOTIFY %s, '%s'" % [channel, payload])
    end
  end

  describe '#payload' do
    subject { activity.send(:payload) }

    it { should eq("'%s'" % payload) }
  end

  describe '#channels' do
    subject { activity.send(:channels) }

    context 'when project is available' do
      let(:activity) { Fabricate(:topic_activity) }
      let(:project) { activity.project }

      it { should include('user_%d' % project.user.id) }
      its(:size) { should eq(1) }
    end

    context 'when project is not available' do
      it { should eq([]) }
    end
  end

end
