require 'spec_helper'

describe User do
  subject(:user) { Fabricate(:user) }

  context '#can?' do
    let(:action) { :read }
    let(:target) {}
    let(:options) {}

    subject(:can) { user.can?(action, target, options) }

    shared_examples 'is writable' do
      context 'writable mode' do
        let(:action) { :write }

        it { should be_true }
      end
    end

    shared_examples 'is not writable' do
      context 'writable mode' do
        let(:options) { {:raise_error => false} }
        let(:action) { :write }

        it { should be_false }
      end
    end

    shared_examples 'no error is raised' do
      context 'and raise_error options is passed' do
        let(:options) { {:raise_error => false} }
        it { should be_false }
      end
    end

    context 'when target is nil' do
      it { should be_true }
      it_behaves_like 'is writable'
    end

    context 'when target is empty' do
      let(:target) { [] }

      it { should be_true }

      it_behaves_like 'is writable'
    end

    context 'when target is an asset' do
      context 'owned by the user' do
        let(:target) { Fabricate(:project, :user => user).logo }
        before { user.should_receive(:assets_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of assets owned by the user' do
          let(:target) { Fabricate(:project, :user => user); user.assets }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:project).logo }
        before { user.should_receive(:assets_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of assets not owned by the user' do
          let(:target) { Fabricate(:project); Asset.all }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within one of the user projects' do
        let(:project) { Fabricate(:project_with_boards, :user => user) }
        let(:board) { project.boards.first }
        let(:target) do
          Fabricate('card/photo', :board => board, :project => project).image
        end
        before { user.should_receive(:assets_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times {
              Fabricate('card/photo', :board => board, :project => project) }
            Asset.where(:project_id => project.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a project not owned by the user' do
        let(:project) { Fabricate(:project) }
        let(:target) { Fabricate('card/photo', :project => project).image }
        before { user.should_receive(:assets_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/photo', :project => project) }
            Asset.where(:project_id => project.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a board owned by the user' do
        let(:board) { Fabricate(:board, :user => user) }
        let(:target) { board.cover }
        before { user.should_receive(:assets_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/photo', :board => board) }
            Asset.where(:board_id => board.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a board not owned by the user' do
        let(:board) { Fabricate(:board) }
        let(:target) { board.cover }
        before { user.should_receive(:assets_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/photo', :board => board) }
            Asset.where(:board_id => board.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a board' do
      context 'owned by the user' do
        let(:target) { Fabricate(:board, :user => user) }
        before { user.should_receive(:boards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of boards owned by the user' do
          let(:target) { Fabricate(:board, :user => user); user.boards }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:board) }
        before { user.should_receive(:boards_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of boards not owned by the user' do
          let(:target) { Fabricate(:board); Board.all }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within one of the user projects' do
        let(:project) { Fabricate(:project, :user => user) }
        let(:target) do
          Fabricate(:board, :project => project)
        end
        before { user.should_receive(:boards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times {
              Fabricate(:board, :project => project) }
            Board.where(:project_id => project.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a project not owned by the user' do
        let(:project) { Fabricate(:project) }
        let(:target) { Fabricate(:board, :project => project) }
        before { user.should_receive(:boards_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:board, :project => project) }
            Board.where(:project_id => project.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a card' do
      context 'owned by the user' do
        let(:target) { Fabricate('card/phrase', :user => user) }
        before { user.should_receive(:cards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of cards owned by the user' do
          let(:target) { Fabricate('card/phrase', :user => user); user.cards }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate('card/phrase') }
        before { user.should_receive(:cards_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of boards not owned by the user' do
          let(:target) { Fabricate('card/phrase'); Card.all }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within one of the user projects' do
        let(:project) { Fabricate(:project_with_boards, :user => user) }
        let(:board) { project.boards.first }
        let(:target) do
          Fabricate('card/phrase', :board => board, :project => project)
        end
        before { user.should_receive(:cards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times {
              Fabricate('card/phrase', :board => board, :project => project) }
            Card.where(:project_id => project.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a project not owned by the user' do
        let(:project) { Fabricate(:project) }
        let(:target) { Fabricate('card/phrase', :project => project) }
        before { user.should_receive(:cards_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/phrase', :project => project) }
            Card.where(:project_id => project.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a board owned by the user' do
        let(:board) { Fabricate(:board, :user => user) }
        let(:target) { Fabricate('card/phrase', :board => board) }
        before { user.should_receive(:cards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/phrase', :board => board) }
            Card.where(:board_id => board.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a board not owned by the user' do
        let(:board) { Fabricate(:board) }
        let(:target) { Fabricate('card/phrase', :board => board) }
        before { user.should_receive(:cards_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate('card/phrase', :board => board) }
            Card.where(:board_id => board.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a team' do
      let(:team) { Fabricate(:team) }
      let(:target) { team }

      it { should be_true }
      it_behaves_like 'is not writable'

      context 'or a set of such' do
        let(:target) { Team.where(:id => team.id) }

        it { should be_true }
        it_behaves_like 'is not writable'
      end

      context 'or a team banner' do
        let(:target) { team.banner }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) { Asset::Banner.where(:assetable => team) }

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a membership' do
      let(:target) { Fabricate(:project_membership) }

      it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like 'is not writable'
      it_behaves_like 'no error is raised'

      context 'created by user' do
        let(:target) { Fabricate(:project_membership, :creator => user) }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) { Membership.where(:creator_id => user.id) }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'of the user' do
        let(:target) { Fabricate(:project_membership, :user => user) }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) { Membership.where(:user_id => user.id) }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end
    end

    context 'when target is an object with an user_id' do
      let(:target) { Fabricate(:project, :user => user) }

      it { should be_true }
      it_behaves_like 'is writable'

      context 'different from user id' do
        let(:target) { Fabricate(:project) }

        it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'
      end
    end

    context 'when target is unknown' do
      let(:target) { Object.new }

      it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like 'is not writable'
      it_behaves_like 'no error is raised'
    end

    context 'when target is an activity', :use_truncation do
      context 'owned by the user' do
        let(:target) { user.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of cards owned by the user' do
          let(:target) { user.activities }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:user).activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of boards not owned by the user' do
          let(:target) { Fabricate(:user).activities }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within one of the user projects' do
        let(:project) { Fabricate(:project, :user => user) }
        let(:target) { project.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            Fabricate(:project, :user => user)
            user.activities
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a project not owned by the user' do
        let(:project) { Fabricate(:project) }
        let(:target) { project.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            project.activities
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a board owned by the user' do
        let(:board) { Fabricate(:board, :user => user) }
        let(:target) { board.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            board.activities
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a board not owned by the user' do
        let(:board) { Fabricate(:board) }
        let(:target) { board.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            board.activities
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end
  end
end
