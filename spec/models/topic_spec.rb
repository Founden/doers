require 'spec_helper'

describe Topic do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:board).dependent('') }
  it { should belong_to(:whiteboard).dependent('') }
  it { should belong_to(:aligned_card).dependent('') }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should validate_presence_of(:user) }

  context 'validations' do
    let(:topic) { Fabricate.build(:topic, :board => nil) }
    subject { topic }

    it { should_not be_valid }

    context 'when board is missing' do
      let(:topic) { Fabricate.build(:whiteboard_topic) }

      it { should be_valid }
    end

    context 'when whiteboard is missing' do
      let(:topic) { Fabricate.build(:topic) }

      it { should be_valid }

      context 'and project is missing' do
        let(:topic) { Fabricate.build(:topic, :project => nil) }

        it { should_not be_valid }
      end
    end
  end

  context 'instance' do
    let(:topic) { Fabricate(:topic) }

    subject { topic }

    context 'sanitizes' do
      let(:content) { Faker::HTMLIpsum.body }

      before do
        topic.update_attributes(:title => content[0..250])
        topic.update_attributes(:description => content)
      end

      its(:title) { should eq(Sanitize.clean(content[0..250])) }
      its(:description) { should eq(Sanitize.clean(content)) }
    end
  end

  context 'order defaults to Topic#position' do
    let!(:topics) { Fabricate(:board).topics }
    let(:positions) { topics.count.times.collect{ rand(10..100) } }

    context '#all' do
      subject { Topic.all.map(&:position) }

      it { should eq(Array.new(topics.count){ 0 }) }

      context 'after positions are updated' do
        before do
          topics.each_with_index { |topic, index|
            topic.update_attributes(:position => positions[index]) }
        end

        it { should eq(positions.sort) }
      end
    end
  end
end
