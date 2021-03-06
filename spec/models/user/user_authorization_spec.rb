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
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            ids = 2.times.collect { Fabricate(
              'card/photo', :board => board, :project => project).image.id }
            Asset.where(:id => ids)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
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

      context 'within a project shared with the user' do
        let(:project) {
          Fabricate(:project_membership, :user => user).project }
        let(:board) { Fabricate(:board, :project => project) }
        let(:target) {
          Fabricate('card/photo', :board => board, :project => project).image }
        before { user.should_receive(:assets_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            ids = 2.times.collect {
              Fabricate(
                'card/photo', :board => board, :project => project).image.id }
            Asset.where(:id => ids)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a whiteboard owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard, :user => user) }
        let(:target) {
          Fabricate('cover', :whiteboard => whiteboard, :user => user) }
        before { user.should_receive(:assets_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:cover, :whiteboard => whiteboard) }
            Asset.where(:whiteboard_id => whiteboard.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a whiteboard not owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard) }
        let(:target) { Fabricate('cover', :whiteboard => whiteboard) }
        before { user.should_receive(:assets_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:cover, :whiteboard => whiteboard) }
            Asset.where(:whiteboard_id => whiteboard.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a whiteboard' do
      context 'owned by the user' do
        let(:target) { Fabricate(:whiteboard, :user => user) }
        before { user.should_receive(:whiteboards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of whiteboards owned by the user' do
          let(:target) do
            Fabricate(:whiteboard, :user => user); user.whiteboards
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'shared with the user' do
        let(:target) {
          Fabricate(:whiteboard_membership, :user => user).whiteboard }
        before { user.should_receive(:whiteboards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of whiteboards shared with the user' do
          let(:target) do
            2.times { Fabricate(:whiteboard_membership, :user => user) }
            user.shared_whiteboards
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:whiteboard) }
        before { user.should_receive(:whiteboards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of whiteboards not owned by the user' do
          let(:target) { Fabricate(:whiteboard); Whiteboard.all }

          it { should be_true }
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
          let(:target) do
            Fabricate(:board, :user => user).user.boards
          end

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
          let(:target) { Card.where(:id => Fabricate('card/phrase').id) }

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
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            2.times {
              Fabricate('card/phrase', :board => board, :project => project) }
            Card.where(:project_id => project.id)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
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

      context 'within a project shared with the user' do
        let(:project) {
          Fabricate(:project_membership, :user => user).project }
        let(:board) { Fabricate(:board, :project => project) }
        let(:target) {
          Fabricate('card/photo', :board => board, :project => project) }
        before { user.should_receive(:cards_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            ids = 2.times.collect {
              Fabricate('card/photo', :board => board, :project => project).id }
            Card.where(:id => ids)
          end

          it { should be_true }
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

      before { user.should_receive(:memberships_to).and_call_original }

      it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like 'is not writable'
      it_behaves_like 'no error is raised'

      context 'created by user' do
        let(:target) { Fabricate(:project_membership, :creator => user) }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            Fabricate(:project_membership, :creator => user)
            user.created_memberships
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'of the user' do
        let(:target) { Fabricate(:project_membership, :user => user) }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            Fabricate(:project_membership, :user => user)
            user.project_memberships
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'of the user shared project' do
        let(:project) { Fabricate(:project_membership, :user => user).project }
        let(:target) { Fabricate(:project_membership, :project => project) }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            membership = Fabricate(:project_membership, :project => project)
            Membership.where(:id => membership)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end

      context 'of the user shared board' do
        let(:board) { Fabricate(:board_membership, :user => user).board }
        let(:target) { Fabricate(:board_membership, :board => board) }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            membership = Fabricate(:board_membership, :board => board)
            Membership.where(:id => membership)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end

      context 'of the user shared whiteboard' do
        let(:whiteboard) {
          Fabricate(:whiteboard_membership, :user => user).whiteboard }
        let(:target) {
          Fabricate(:whiteboard_membership, :whiteboard => whiteboard) }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            membership =
              Fabricate(:whiteboard_membership, :whiteboard => whiteboard)
            Membership.where(:id => membership)
          end

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a project' do
      let(:target) { Fabricate(:project) }

      before { user.should_receive(:projects_to).and_call_original }

      it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like 'is not writable'
      it_behaves_like 'no error is raised'

      context 'created by user' do
        let(:target) { Fabricate(:project, :user => user) }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            Fabricate(:project, :user => user).user.created_projects
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'of the user shared project' do
        let(:project) { Fabricate(:project_membership, :user => user).project }
        let(:target) { project }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            project.members.first.shared_projects
          end

          it { should be_true }
          it_behaves_like 'is not writable'
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

    context 'when target is an endorse (same as activity)', :use_truncation do
      let(:target) { Fabricate(:endorse, :user => user) }

      before { user.should_receive(:activities_to).and_call_original }

      it { should be_true }
      it_behaves_like 'is writable'

      context 'or an endorse' do
        let(:target) { Fabricate(:endorse, :user => user) ; user.endorses }

        it { should be_true }
        it_behaves_like 'is writable'
      end
    end

    context 'when target is an activity', :use_truncation do
      context 'owned by the user' do
        let(:target) { user.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such owned by the user' do
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
            project.activities
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within one of the user shared projects' do
        let(:project) { Fabricate(:project_membership, :user => user).project }
        let(:target) { project.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            project.activities
          end

          it { should be_true }
          it_behaves_like 'is not writable'
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

      context 'within a whiteboard owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard, :user => user) }
        let(:target) { whiteboard.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            whiteboard.activities
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a whiteboard not owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard) }
        let(:target) { whiteboard.activities.first }
        before { user.should_receive(:activities_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            whiteboard.activities
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a comment' do
      context 'owned by the user' do
        let(:comment) { Fabricate(:comment, :user => user) }
        let(:target) { comment }
        before { user.should_receive(:comments_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such owned by the user' do
          let(:target) { comment.user.comments }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:comment) }
        before { user.should_receive(:comments_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of boards not owned by the user' do
          let(:target) { Fabricate(:comment).user.comments }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within one of the user projects' do
        let(:project) { Fabricate(:project_membership, :user => user).project }
        let(:target) { Fabricate(:comment, :project => project) }
        before { user.should_receive(:comments_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) { Fabricate(:comment, :project => project).user.comments}

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a whiteboard owned by the user' do
        let(:whiteboard) {
          Fabricate(:whiteboard_membership, :user => user).whiteboard }
        let(:target) { Fabricate(:comment, :whiteboard => whiteboard) }
        before { user.should_receive(:comments_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is not writable'

        context 'or a set of such' do
          let(:target) do
            Fabricate(:comment, :whiteboard => whiteboard).user.comments
          end

          it { should be_true }
          it_behaves_like 'is not writable'
        end
      end
    end

    context 'when target is a topic' do
      context 'owned by the user' do
        let(:target) { Fabricate(:topic, :user => user) }
        before { user.should_receive(:topics_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of topics owned by the user' do
          let(:target) { Fabricate(:topic, :user => user); user.topics }

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'not owned by the user' do
        let(:target) { Fabricate(:topic) }
        before { user.should_receive(:topics_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of topics not owned by the user' do
          let(:target) { Topic.where(:id => Fabricate(:topic).id) }

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a board owned by the user' do
        let(:project) { Fabricate(:project_membership, :user => user).project }
        let(:board) { Fabricate(:board, :project => project) }
        let(:target) { Fabricate(:topic, :board => board, :project => project) }
        before { user.should_receive(:topics_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:topic, :board => board) }
            Topic.where(:board_id => board.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a board not owned by the user' do
        let(:board) { Fabricate(:board) }
        let(:target) { Fabricate(:topic, :board => board) }
        before { user.should_receive(:topics_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:topic, :board => board) }
            Topic.where(:board_id => board.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

      context 'within a whiteboard owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard, :user => user) }
        let(:target) { Fabricate(:topic, :whiteboard => whiteboard) }
        before { user.should_receive(:topics_to).and_call_original }

        it { should be_true }
        it_behaves_like 'is writable'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:topic, :whiteboard => whiteboard) }
            Topic.where(:whiteboard_id => whiteboard.id)
          end

          it { should be_true }
          it_behaves_like 'is writable'
        end
      end

      context 'within a whiteboard not owned by the user' do
        let(:whiteboard) { Fabricate(:whiteboard) }
        let(:target) { Fabricate(:topic, :whiteboard => whiteboard) }
        before { user.should_receive(:topics_to).and_call_original }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like 'is not writable'
        it_behaves_like 'no error is raised'

        context 'or a set of such' do
          let(:target) do
            2.times { Fabricate(:topic, :whiteboard => whiteboard) }
            Topic.where(:whiteboard_id => whiteboard.id)
          end

          it { expect{subject}.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like 'is not writable'
        end
      end

    end

  end
end
