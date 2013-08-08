require 'spec_helper'

describe User, :use_truncation do
  let(:user) { Fabricate(:user) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:cards).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:assets).dependent(:destroy) }
  it { should have_many(:images).dependent('') }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_inclusion_of(:interest).in_array(User::INTERESTS.values) }

  context 'unconfirmed' do
    subject { User.new }

    its(:confirmed?) { should be_false }
  end

  context 'instance' do
    subject { user }

    it { should be_valid }
    its('identities.first.uid') { should eq(user.email) }
    its(:email) { should_not be_empty }
    its(:name) { should_not be_empty }
    its(:nicename) { should eq(user.name) }
    its(:external_id) { should eq(user.external_id) }
    its(:interest) { should be_blank }
    its(:company) { should be_blank }
    its(:confirmed?) { should be_true }
    its(:admin?) { should be_false }
    its(:importing) { should be_false }

    context '#newsletter_allowed?' do
      its(:newsletter_allowed?) { should be_true }

      context 'when user opted against it' do
        before do
          user.update_attributes(:newsletter_allowed => false)
        end

        its(:newsletter_allowed?) { should be_false }
      end
    end

    context '#admin?' do
      before do
        user.update_attributes(:email => 'test@geekcelerator.com')
      end

      its(:admin?) { should be_true }
    end

    context 'sends a confirmation email' do
      before do
        UserMailer.should_receive(:confirmed)
      end

      it { user.update_attributes(:confirmed => '1') }
    end

    context '#nicename when #name is blank' do
      before { user.update_attribute(:name, nil) }

      its(:nicename) { should eq(user.email) }
    end

    context 'on duplicates' do
      subject { Fabricate.build(:user, :email => user.email) }

      it { should_not be_valid }
    end

    context '#can?' do
      let(:action) { :read }
      let(:target) {}
      let(:options) {}

      subject(:can) { user.can?(action, target, options) }

      context 'when target is nil' do
        it { should be_true }
      end

      context 'when target is empty' do
        it { should be_true }
      end

      context 'when target is an asset' do
        context 'owned by the user' do
          let(:target) { Fabricate(:project, :user => user).logo }
          before { user.should_receive(:assets_to).and_call_original }

          it { should be_true }

          context 'or a set of assets owned by the user' do
            let(:target) { Fabricate(:project, :user => user); user.assets }

            it { should be_true }
          end
        end

        context 'not owned by the user' do
          let(:target) { Fabricate(:project).logo }
          before { user.should_receive(:assets_to).and_call_original }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }

          context 'or a set of assets not owned by the user' do
            let(:target) { Fabricate(:project); Asset.all }

            it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          end

          context 'and raise_error options is passed' do
            let(:options) { {:raise_error => false} }
            it { should be_false }
          end
        end
      end

      context 'when target is a board' do
        context 'owned by the user' do
          let(:target) { Fabricate(:board, :user => user) }
          before { user.should_receive(:boards_to).and_call_original }

          it { should be_true }

          context 'or a set of boards owned by the user' do
            let(:target) { Fabricate(:board, :user => user); user.boards }

            it { should be_true }
          end
        end

        context 'not owned by the user' do
          let(:target) { Fabricate(:board) }
          before { user.should_receive(:boards_to).and_call_original }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }

          context 'or a set of boards not owned by the user' do
            let(:target) { Fabricate(:board); Board.all }

            it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          end

          context 'and raise_error options is passed' do
            let(:options) { {:raise_error => false} }
            it { should be_false }
          end
        end
      end

      context 'when target is a card' do
        context 'owned by the user' do
          let(:target) { Fabricate('card/phrase', :user => user) }
          before { user.should_receive(:cards_to).and_call_original }

          it { should be_true }

          context 'or a set of cards owned by the user' do
            let(:target) { Fabricate('card/phrase', :user => user); user.cards }

            it { should be_true }
          end
        end

        context 'not owned by the user' do
          let(:target) { Fabricate('card/phrase') }
          before { user.should_receive(:cards_to).and_call_original }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }

          context 'or a set of boards not owned by the user' do
            let(:target) { Fabricate('card/phrase'); Card.all }

            it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          end

          context 'and raise_error options is passed' do
            let(:options) { {:raise_error => false} }
            it { should be_false }
          end
        end
      end

      context 'when target is an object with an user_id' do
        let(:target) { Fabricate(:project, :user => user) }

        it { should be_true }

        context 'different from user id' do
          let(:target) { Fabricate(:project) }

          it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }

          context 'and raise_error options is passed' do
            let(:options) { {:raise_error => false} }
            it { should be_false }
          end
        end
      end

      context 'when target is unknown' do
        let(:target) { Object.new }

        it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }

        context 'and raise_error options is passed' do
          let(:options) { {:raise_error => false} }
          it { should be_false }
        end
      end
    end

    context '#boards_to(:read)' do
      subject(:boards_to_read) { user.boards_to(:read) }

      it { boards_to_read.should be_empty }

      context 'when created a board' do
        let!(:board) { Fabricate(:board, :author => user) }

        its(:count) { should eq(1) }
        its('first.id') { should eq(board.id) }
      end

      context 'when there is a public board' do
        let!(:board) { Fabricate(:board, :status => Board::STATES.last) }

        its(:count) { should eq(1) }
        its('first.id') { should eq(board.id) }
      end

      context 'when branched a board' do
        let!(:board) { Fabricate(:branched_board, :user => user) }

        its(:count) { should eq(2) }
        it { boards_to_read.should include(board) }
      end

      context 'when an owned project has boards' do
        let!(:project) { Fabricate(:project_with_boards, :user => user) }
        let!(:project_board) { Fabricate(:branched_board, :project => project) }

        its(:count) {
          should eq(project.boards.count +
                    Board.where(:status => Board::STATES.last).count) }

        context 'the private boards should not be included' do
          let!(:private_board) { Fabricate(:branched_board) }

          it { boards_to_read.should_not include(private_board) }
        end
      end
    end
  end

end
