require 'spec_helper'

describe Board do
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:whiteboard) }
  it { should have_one(:cover).dependent(:destroy) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:members) }
  it { should have_many(:invitations).dependent(:destroy) }
  it { should have_many(:topics).dependent('') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should ensure_inclusion_of(:status).in_array(Board::STATES) }

  context 'public scope' do
    let!(:board) { Fabricate(:board) }

    subject { Board }

    its('public.count') { should eq(Board.where(:status => 'public').count) }
  end

  context 'instance' do
    let(:board) { Fabricate(:board) }

    subject { board }

    its(:status) { should eq(Board::STATES.first) }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before do
        board.update_attributes(:title => content[0..250])
        board.update_attributes(:description => content)
      end

      its(:title) { should eq(Sanitize.clean(content[0..250])) }
      its(:description) { should eq(Sanitize.clean(content)) }
    end

    context '#progress' do
      its(:progress) { should eq(0) }

      context 'when board has no topics' do
        let(:board) { Fabricate(:board, :topics_count => 0) }
        its(:progress) { should eq(100) }
      end

      context 'when board has a topic aligned' do
        let(:board) { Fabricate(:board, :topics_count => 5) }
        let(:topic) { board.topics.first }
        let(:card) { Fabricate('card/paragraph',
          :project => board.project, :board => board, :topic => topic) }

        subject do
          topic.update_attribute(:aligned_card, card)
          board
        end

        its(:progress) { should eq(20) }
      end
    end

    context '#whiteboardify' do
      let(:whiteboardifier) { Fabricate(:user) }

      subject(:whiteboard) { board.whiteboardify(whiteboardifier) }

      its(:boards) { should include(board) }

      %w(title description position user_id).each do |attr_name|
        context "topics #{attr_name}" do
          subject { whiteboard.topics.pluck(attr_name).sort }

          it { should eq(board.topics.pluck(attr_name).sort) }
        end
      end
    end

  end
end
