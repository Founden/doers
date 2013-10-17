require 'spec_helper'

describe Card::Phrase, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:card) { Fabricate('card/phrase', :user => user) }

  context '#activities' do
    subject(:activities) { card.activities }

    context 'on create' do
      subject{ activities.first }

      its(:user) { should eq(card.user) }
      its(:project) { should eq(card.project) }
      its(:board) { should eq(card.board) }
      its(:topic) { should eq(card.topic) }
      its(:card) { should eq(card) }
      its(:slug) { should eq('create-card-phrase') }
    end

    context 'on update' do
      before { card.update_attributes(:title => Faker::Lorem.sentence) }

      subject{ activities.first }

      it { activities.count.should eq(2) }
      its(:user) { should eq(card.user) }
      its(:project) { should eq(card.project) }
      its(:board) { should eq(card.board) }
      its(:topic) { should eq(card.topic) }
      its(:card) { should eq(card) }
      its(:slug) { should eq('update-card-phrase') }
    end

    context 'on update with a custom postfix' do
      let(:alignment_slug) { Faker::Lorem.word }

      before do
        card.activity_alignment_slug = alignment_slug
        card.update_attributes(:title => Faker::Lorem.sentence)
      end

      subject{ activities.first }

      it { activities.count.should eq(2) }
      its(:user) { should eq(card.user) }
      its(:project) { should eq(card.project) }
      its(:board) { should eq(card.board) }
      its(:topic) { should eq(card.topic) }
      its(:card) { should eq(card) }
      its(:slug) { should include(alignment_slug) }
    end

    context 'on delete' do
      before { card.destroy }

      subject { user.activities.first }

      it { activities.count.should eq(2) }
      its(:user) { should eq(card.user) }
      its(:project) { should eq(card.project) }
      its(:board) { should eq(card.board) }
      its(:topic) { should eq(card.topic) }
      its(:card_id) { should_not be_nil }
      its(:slug) { should eq('destroy-card-phrase') }
    end
  end
end
