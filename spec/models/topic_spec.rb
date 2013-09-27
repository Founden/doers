require 'spec_helper'

describe Topic do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }

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

  context 'validation' do
    let(:project) {}
    let(:board) {}

    subject { Fabricate.build(:topic, :project => project, :board => board) }

    context 'when project and board is missing' do
      it { should_not be_valid }
    end

    context 'when project is missing' do
      let(:project) { Fabricate(:project) }

      it { should be_valid }
    end

    context 'when board is missing' do
      let(:board) { Fabricate(:board) }

      it { should be_valid }
    end

    context 'when project and board are present' do
      let(:project) { Fabricate(:project) }
      let(:board) { Fabricate(:board) }

      it { should be_valid }
    end
  end

  context 'order defaults to Topic#position', :pending do
    let!(:topics) { Fabricate(:topic).cards }
    let(:positions) { cards.count.times.collect{ rand(10..100) } }

    context '#all' do
      subject { Card.all.map(&:position) }

      it { should eq(Array.new(cards.count){ 0 }) }

      context 'after positions are updated' do
        before do
          cards.each_with_index { |card, index|
            card.update_attributes(:position => positions[index]) }
        end

        it { should eq(positions.sort) }
      end
    end
  end
end