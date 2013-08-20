require 'spec_helper'

describe Card::Phrase, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:card) { Fabricate('card/phrase', :user => user) }

  context '#activities' do
    subject { card.activities }

    context 'on create' do
      its(:size) { should eq(1) }

      its('last.user') { should eq(card.user) }
      its('last.project') { should eq(card.project) }
      its('last.board') { should eq(card.board) }
      its('last.trackable') { should eq(card) }
      its('last.slug') { should eq('create-card-phrase') }
    end

    context 'on update' do
      before { card.update_attributes(:title => Faker::Lorem.sentence) }

      its(:size) { should eq(2) }
      its('last.user') { should eq(card.user) }
      its('last.project') { should eq(card.project) }
      its('last.board') { should eq(card.board) }
      its('last.trackable') { should eq(card) }
      its('last.slug') { should eq('update-card-phrase') }
    end

    context 'on delete' do
      before { card.destroy }

      subject { user.activities }

      its(:size) { should eq(3) }
      its('last.user') { should eq(card.user) }
      its('last.project') { should eq(card.project) }
      its('last.board') { should eq(card.board) }
      its('last.trackable_id') { should_not be_nil }
      its('last.trackable_type') { should_not be_nil }
      its('last.slug') { should eq('destroy-card-phrase') }
    end
  end
end
