require 'spec_helper'

describe Activity, :use_truncation do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:whiteboard) }
  it { should belong_to(:project) }
  it { should belong_to(:card) }
  it { should belong_to(:comment) }
  it { should belong_to(:topic) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:slug) }

  context 'caches name' do
    let(:user) { Fabricate(:user) }
    let!(:trackable) { user }

    subject { trackable.activities.first }

    context 'for the user' do
      its(:user_name) { should eq(user.nicename) }
    end

    context 'for the project' do
      let(:project) { Fabricate(:project, :user => user) }
      let(:trackable) { project }

      its(:user_name) { should eq(user.nicename) }
      its(:project) { should eq(project) }
      its(:project_title) { should eq(project.title) }
    end

    context 'for the board' do
      let(:board) { Fabricate(:board, :user => user) }
      let(:trackable) { board }
      subject { trackable.activities.last }

      its(:user_name) { should eq(user.nicename) }
      its(:board) { should eq(board) }
      its(:board_title) { should eq(board.title) }
    end

    context 'for the card' do
      let(:card) { Fabricate(:card, :user => user) }
      let(:trackable) { card }

      its(:user_name) { should eq(user.nicename) }
      its(:card) { should eq(card) }
      its(:card_title) { should eq(card.title) }
    end

    context 'for the topic' do
      let(:topic) { Fabricate(:topic, :user => user) }
      let(:trackable) { topic }

      its(:user_name) { should eq(user.nicename) }
      its(:topic) { should eq(topic) }
      its(:topic_title) { should eq(topic.title) }
    end
  end

  context '#activity_slug' do
    subject(:project) { Fabricate(:project) }
    let(:title) { Faker::Lorem.sentence }
    let(:slug) { Faker::Lorem.word }

    before do
      project.update_attributes(
        :title => title, :activity_postfix => slug)
    end

    its(:title) { should eq(title) }
    its('activities.first.slug') { should include(slug) }
  end

  context '#activity_author' do
    subject(:project) { Fabricate(:project) }
    let(:some_user) { Fabricate(:user) }
    let(:title) { Faker::Lorem.sentence }

    before do
      project.update_attributes(
        :title => title, :activity_author => some_user)
    end

    its(:title) { should eq(title) }
    its('activities.first.user') { should eq(some_user) }
  end

  context '#remove_previous_if_same_as' do
    subject(:project) { Fabricate(:project) }

    its('activities.count') { should eq(1) }

    context 'after calling save' do
      before { project.save }

      its('activities.count') { should eq(2) }
    end

    context 'after calling #save multiple times' do
      before { rand(2..5).times{ sleep(1); project.save } }

      its('activities.count') { should eq(2) }
    end

    context 'after calling #save in < 10 minutes' do
      before do
        project.save
        Timecop.freeze(DateTime.now + 5.minutes) do
          project.save
        end
      end

      its('activities.count') { should eq(2) }
    end

    context 'after calling #save after 10 minutes' do
      before do
        project.save
        Timecop.freeze(DateTime.now + 11.minutes) do
          project.save
        end
      end

      its('activities.count') { should eq(3) }
    end
  end

  context 'order defaults to Activity#updated_at' do
    let!(:activities) { Fabricate(:board).user.activities }
    let(:dates) { activities.pluck('updated_at').map(&:to_i) }

    context '#all' do
      subject do
        activities.order(:updated_at => :desc).pluck('updated_at').map(&:to_i)
      end

      it { should eq(dates) }
      it { should eq(dates.sort.reverse) }
    end
  end
end
