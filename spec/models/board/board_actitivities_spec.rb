require 'spec_helper'

describe Board, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:board) { Fabricate(:board, :user => user, :topics_count => 0) }

  context '#activities' do
    subject { board.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(board.user) }
      its('first.project') { should eq(board.project) }
      its('first.board') { should eq(board) }
      its('first.slug') { should eq('create-board') }
    end

    context 'on update' do
      before { board.update_attributes(:title => Faker::Company.name) }

      its(:size) { should eq(1) }
    end

    context 'on delete' do
      before { board.destroy }

      subject { user.activities }

      its('last.user') { should eq(user) }
      its('last.project') { should eq(board.project) }
      its('last.board_id') { should_not be_nil }
      its('last.slug') { should eq('destroy-board') }
    end
  end
end
