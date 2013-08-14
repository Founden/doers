require 'spec_helper'

describe User, :use_truncation do
  let(:user) { Fabricate(:user) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:boards).dependent('') }
  it { should have_many(:authored_boards).dependent('') }
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

    context '#boards_to' do
      shared_examples 'its found' do
        its(:count) { should eq(1) }
        its('first.id') { should eq(board.id) }
      end

      let(:action) { :read }
      subject(:boards_to) { user.boards_to(action) }

      it { should be_empty }

      context 'when created a board' do
        let!(:board) { Fabricate(:board, :author => user) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a public board' do
        let!(:board) { Fabricate(:board, :status => Board::STATES.last) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it { should be_empty }
        end
      end

      context 'when branched a board' do
        let!(:board) { Fabricate(:branched_board, :user => user) }

        its(:count) { should eq(2) }
        it { should include(board) }

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when an owned project has boards' do
        let!(:project) { Fabricate(:project_with_boards, :user => user) }
        let!(:project_board) { Fabricate(:branched_board, :project => project) }

        its(:count) {
          should eq(project.boards.count + Board.public.count) }

        context 'when action is set to :write' do
          let(:action) { :write }

          its(:count) { should eq((user.boards + project.boards).uniq.count) }
        end

        context 'the private boards should not be included' do
          let!(:private_board) { Fabricate(:branched_board) }

          it { should_not include(private_board) }

          context 'when action is set to :write' do
            let(:action) { :write }

            its(:count) { should eq(project.boards.count) }
          end
        end
      end
    end

    context '#assets_to' do
      shared_examples 'its found' do
        its(:count) { should eq(1) }
        its('first.id') { should eq(asset.id) }
      end

      let(:action) { :read }
      subject(:assets_to) { user.assets_to(action) }

      it { should be_empty }

      context 'when user has an asset' do
        let!(:asset) { Fabricate('card/photo', :user => user).image }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when user project has an asset' do
        let!(:asset) { Fabricate(:project, :user => user).logo }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a created board asset' do
        let(:board) { Fabricate(:board, :author => user) }
        let!(:asset) { Fabricate(
          :image, :user => user, :board => board, :assetable => board) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a branched board asset' do
        let(:board) { Fabricate(:board, :user => user) }
        let!(:asset) { Fabricate(
          :image, :user => user, :board => board, :assetable => board) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a public board asset' do
        let(:board) { Fabricate(:public_board, :card_types => %w(card/photo)) }
        let!(:asset) { board.cards.first.image }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it { should be_empty }
        end
      end
    end

    context '#cards_to' do
      shared_examples 'its found' do
        its(:count) { should eq(1) }
        its('first.id') { should eq(card.id) }
      end

      let(:action) { :read }
      subject(:cards_to) { user.cards_to(action) }

      it { should be_empty }

      context 'when user has a card' do
        let!(:card) { Fabricate('card/phrase', :user => user) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when user project has a card' do
        let(:project) {Fabricate(:project, :user => user) }
        let(:board) {Fabricate(:board, :user => user) }
        let!(:card) { Fabricate(
          'card/photo', :user => user, :project => project, :board => board) }

        its(:count) { should eq(user.cards.count) }
        its('first.id') { should eq(card.id) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a public board card' do
        let(:board) { Fabricate(:public_board, :card_types => %w(card/phrase)) }
        let!(:card) { board.cards.first }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it { should be_empty }
        end
      end

      context 'when there is a created board card' do
        let(:board) { Fabricate(:board, :author => user) }
        let!(:card) { Fabricate('card/phrase', :user => user, :board => board) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end

      context 'when there is a branched board asset' do
        let(:board) { Fabricate(:board, :user => user) }
        let!(:card) { Fabricate('card/phrase', :user => user, :board => board) }

        it_should_behave_like 'its found'

        context 'when action is set to :write' do
          let(:action) { :write }

          it_should_behave_like 'its found'
        end
      end
    end
  end
end
