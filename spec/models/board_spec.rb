require 'spec_helper'

describe Board do
  let(:board) { Fabricate(:board) }

  it { should belong_to(:user) }
  it { should belong_to(:author) }
  it { should belong_to(:project) }
  it { should belong_to(:parent_board) }
  it { should have_many(:branches).dependent('') }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:status).in_array(Board::STATES) }

  context 'instance' do
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

    context 'can have branches' do
      let(:title) { Faker::Lorem.sentence }
      let(:user) { Fabricate(:user) }
      let!(:branch) { board.branches.create(:title => title, :user => user) }

      its('branches.count') { should eq(1) }

      context 'parent board' do
        subject { branch }

        its(:parent_board) { should eq(board) }
      end

      context 'only with user present' do
        let(:user) { nil }

        subject { branch }

        its(:valid?) { should be_false }
      end

    end
  end
end
