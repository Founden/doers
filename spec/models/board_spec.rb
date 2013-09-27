require 'spec_helper'

describe Board do
  it { should belong_to(:user) }
  it { should belong_to(:author) }
  it { should belong_to(:project) }
  it { should belong_to(:parent_board) }
  it { should belong_to(:team) }
  it { should have_one(:cover).dependent(:destroy) }
  it { should have_many(:branches).dependent('') }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:members) }
  it { should have_many(:tags) }
  it { should have_many(:invitations).dependent(:destroy) }
  it { should have_many(:topics).dependent('') }

  it { should validate_presence_of(:author) }
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:status).in_array(Board::STATES) }

  context 'public scope' do
    let!(:branched_board) { Fabricate(:branched_board) }

    subject { Board }

    its('public.count') { should eq(Board.where(:status => 'public').count) }
  end

  context 'instance' do
    let(:board) { Fabricate(:board) }

    subject { board }

    it { should respond_to(:tag_names) }
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
      let(:project) { Fabricate(:project, :user => user) }
      let!(:branch) { board.branches.create(
        :title => title, :user => user, :project => project) }

      its('branches.count') { should eq(1) }

      context 'branch' do
        subject { branch }

        its(:parent_board) { should eq(board) }

        context 'only with user present' do
          let(:user) { nil }
          let(:project) { Fabricate(:project) }

          its(:valid?) { should be_false }
        end

        context 'only with project present' do
          let(:project) { nil }

          subject { branch }

          its(:valid?) { should be_false }
        end

        context 'is not allowed to duplicate' do
          let(:duplicate_branch) do
            board.branches.build(
              :title => title, :user => user, :project => project)
          end

          before do
            # Make it a public board
            board.update_attributes(:status => Board::STATES.last)
            # Create first branch
            branch
          end

          # Try to create the second branch
          subject { duplicate_branch }

          its(:valid?) { should be_false }
          its(:has_public_parent_board?) { should be_true }
        end
      end
    end

    context '#branch_for', :pending do
      let(:brancher) { Fabricate(:user_with_projects, :projects_count => 1) }
      let(:project) { brancher.projects.first }
      let(:board) { Fabricate(:public_board) }
      let(:title) { Faker::Lorem.sentence }
      let(:params) { {:title => title} }

      context 'creates a new branch' do
        subject(:branch){ board.branch_for(brancher, project, params) }

        its(:title) { should eq(title) }
        its(:parent_board) { should eq(board) }
        its(:project) { should eq(project) }
        its(:user) { should eq(brancher) }
        its('cards.count') { should eq(board.cards.count) }

        context 'if title is blank' do
          let(:title) { }

          its(:new_record?) { should be_true }
          its(:errors) { should_not be_empty }
          its(:valid?) { should be_false }
        end

        context 'with all the parent board cards' do
          subject { branch.cards.pluck('type').sort }

          it { should eq(board.cards.pluck('type').sort) }
        end

        context 'with all the cards parent' do
          subject { board.card_ids.sort }

          it { should eq(branch.cards.pluck('parent_card_id').sort) }
        end
      end

      context 'if board is owned by branching user' do
        let(:board) do
          Fabricate(:branched_board, :user => brancher, :project => project)
        end

        it do
          expect {
            board.branch_for(brancher, project, params) }.to_not raise_error
        end
      end

      context 'if board is not accessible' do
        let(:board) { Fabricate(:board) }

        it do
          expect { board.branch_for(brancher, project, params) }.to raise_error
        end
      end

      context 'if project is not accessible' do
        let(:project) { Fabricate(:project) }

        it do
          expect { board.branch_for(brancher, project, params) }.to raise_error
        end
      end

    end
  end
end
