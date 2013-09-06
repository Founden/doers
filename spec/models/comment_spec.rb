require 'spec_helper'

describe Comment do
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:parent_comment) }
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should belong_to(:commentable) }

  it { should validate_presence_of(:content) }
  it { should_not ensure_inclusion_of(
    :external_type).in_array(Doers::Config.external_types) }

  context 'instance' do
    subject(:comment) { Fabricate(:comment) }

    it { should be_valid }
    its(:parent_comment) { should be_nil }
    its(:external?) { should be_false }
    its('author.nicename') { should eq(comment.user.nicename) }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before { comment.update_attributes(:content => content) }

      its(:content) {
        should eq(Sanitize.clean(content)) }
    end

    context 'having a parent comment' do
      subject(:comment) { Fabricate(:comment_with_parent) }

      its(:parent_comment) { should_not be_nil }
    end

    context '#external?' do
      subject(:comment) { Fabricate(:comment_from_angel_list) }

      it { should ensure_inclusion_of(
        :external_type).in_array(Doers::Config.external_types) }
      its(:external?) { should be_true }
      its('author.nicename') { should eq(comment.external_author_name) }
    end
  end

  context '#activities', :use_truncation do
    subject(:comment) { Fabricate(:card_comment) }

    context 'first' do
      subject { comment.commentable.activities.reload.first }

      its(:slug) { should eq('create-comment') }
      its(:comment_id) { should eq(comment.id.to_s) }
    end

    context 'first for a comment with parent comment' do
      let(:with_parent) { Fabricate(:card_comment, :parent_comment => comment) }
      subject { with_parent.commentable.activities.reload.first }

      its(:slug) { should_not eq('create-comment') }
      its(:comment_id) { should be_blank }
    end
  end

end
