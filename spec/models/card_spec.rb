require 'spec_helper'

describe Card do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should have_many(:activities).dependent('') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:board) }
  it { should validate_presence_of(:title_hint) }
  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:help) }
  it { should ensure_inclusion_of(:style).in_array(Card::STYLES) }
  it { should validate_numericality_of(:position) }

  context 'instance' do
    let(:card) { Fabricate(:card) }

    subject { card }

    its(:position) { should eq(0) }

    context 'sanitizes' do
      let(:content) { Faker::HTMLIpsum.body }

      context '#title' do
        before { card.update_attributes(:title => content[0..250]) }

        its(:title) { should eq(Sanitize.clean(content[0..250])) }
      end

      context '#content' do
        before { card.update_attributes(:content => content) }

        its(:content) { should eq(Sanitize.clean(content)) }
      end

      context '#question' do
        before { card.update_attributes(:question => content[0..250]) }

        its(:question) { should eq(Sanitize.clean(content[0..250])) }
      end

      context '#help' do
        before { card.update_attributes(:help => content) }

        its(:help) { should eq(Sanitize.clean(content)) }
      end

      context '#title_hint' do
        before { card.update_attributes(:title_hint => content[0..250]) }

        its(:title_hint) { should eq(Sanitize.clean(content[0..250])) }
      end
    end
  end

  context 'order defaults to Card#position' do
    let!(:cards) { Fabricate(:public_board).cards }
    let(:positions) { cards.count.times.collect{ rand(10..100) } }

    context '#all' do
      subject { Card.all.map(&:position) }

      it { should eq(Array.new(cards.count){ 0 }) }

      context 'after positions are updated' do
        before do
          cards.each_with_index { |card, index|
            card.update_attributes(:position => positions[index]) }
        end

        it { should eq(positions.sort) }
      end
    end
  end
end
