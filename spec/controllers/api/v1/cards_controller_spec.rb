require 'spec_helper'

describe Api::V1::CardsController do
  let(:user) { Fabricate(:user) }
  let(:project) { Fabricate(:project, :user => user) }
  let(:board) { Fabricate(:branched_board, :user => user, :project => project) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:card_ids) { [] }

    before { get(:index, :ids => card_ids) }

    subject(:api_card) { json_to_ostruct(response.body) }

    its('cards.size') { should eq(0) }

    context 'when queried ids are available' do
      let(:card_ids) do
        [Fabricate('card/phrase', :project => project).id]
      end

      its('cards.size') { should eq(1) }
    end

    context 'when queried ids are not available' do
      let(:card_ds) { Fabricate('card/phrase').id }

      its('cards.size') { should eq(0) }
    end
  end

  describe '#show' do
    context 'for available cards' do
      let(:card) {
        Fabricate('card/phrase', :project => project, :board => board) }
      let(:card_id) { card.id }

      before { get(:show, :id => card_id) }

      subject(:api_card) { json_to_ostruct(response.body, :card) }

      its(:id) { should eq(card.id) }
      its(:title) { should eq(card.title) }
      its(:position) { should eq(card.position) }
      its(:type) { should eq(card.type.to_s.sub('Card::', '')) }
      its(:last_update) { should eq(card.updated_at.to_s(:pretty)) }
      its(:updated_at) { should_not be_nil }
      its(:user_id) { should eq(card.user.id) }
      its(:user_nicename) { should eq(card.user.nicename) }
      its(:project_id) { should eq(card.project.id) }
      its(:board_id) { should eq(card.board.id) }

      context 'phrase card keys' do
        its('keys.size') { should eq(11) }
        its(:content) { should eq(card.content) }
      end

      context 'paragraph card keys' do
        let(:card) {
          Fabricate('card/paragraph', :project => project, :board => board) }

        its('keys.size') { should eq(11) }
        its(:content) { should eq(card.content) }
      end

      context 'number card keys' do
        let(:card) {
          Fabricate('card/number', :project => project, :board => board) }

        its('keys.size') { should eq(11) }
        its(:content) { should eq(card.content) }
      end

      context 'timestamp card keys' do
        let(:card) {
          Fabricate('card/timestamp', :project => project, :board => board) }

        its('keys.size') { should eq(12) }
        its(:timestamp) { should eq(card.timestamp) }
        its(:parsed_timestamp) {
          should eq(DateTime.parse(card.timestamp).to_s(:pretty)) }
      end

      context 'interval card keys' do
        let(:card) {
          Fabricate('card/interval', :project => project, :board => board) }

        its('keys.size') { should eq(13) }
        its(:minimum) { should eq(card.minimum) }
        its(:maximum) { should eq(card.maximum) }
        its(:selected) { should eq(card.selected) }
      end

      context 'book card keys' do
        let(:card) {
          Fabricate('card/book', :project => project, :board => board) }

        its('keys.size') { should eq(15) }
        its(:url) { should eq(card.url) }
        its(:book_title) { should eq(card.book_title) }
        its(:book_authors) { should eq(card.book_authors) }
        its(:asset_id) { should eq(card.image.id) }
      end

      context 'photo card keys' do
        let(:card) {
          Fabricate('card/photo', :project => project, :board => board) }

        its('keys.size') { should eq(12) }
        its(:image_url) { should eq(card.image.attachment.url) }
        its(:asset_id) { should eq(card.image.id) }
      end

      context 'video card keys' do
        let(:card) {
          Fabricate('card/video', :project => project, :board => board) }

        its('keys.size') { should eq(14) }
        its(:image_url) { should eq(card.image.attachment.url) }
        its(:video_id) { should eq(card.video_id) }
        its(:provider) { should eq(card.provider) }
        its(:asset_id) { should eq(card.image.id) }
      end

      context 'map card keys' do
        let(:card) {
          Fabricate('card/map', :project => project, :board => board) }

        its('keys.size') { should eq(14) }
        its(:location) { should eq(card.location) }
        its(:address) { should eq(card.address) }
        its(:latitude) { should eq(card.latitude) }
        its(:longitude) { should eq(card.longitude) }
      end

      context 'link card keys' do
        let(:card) {
          Fabricate('card/link', :project => project, :board => board) }

        its('keys.size') { should eq(12) }
        its(:url) { should eq(card.url) }
        its(:excerpt) { should eq(card.excerpt) }
      end
    end
  end

  describe '#update' do
    let(:card) { Fabricate('card/phrase', :project => project, :board => board)}
    let(:card_attrs) { Fabricate.attributes_for('card/phrase') }
    let(:card_id) { card.id }

    before { patch(:update, :id => card_id, :card => card_attrs) }

    subject(:api_card) { json_to_ostruct(response.body, :card) }

    it 'handles wrong attributes' do
      attrs = Fabricate.attributes_for('card/phrase')
      attrs['timestamp'] = DateTime.now

      expect {
        patch(:update, :card => attrs, :id => card_id)
      }.to raise_error
    end

    it 'does nothing to a not owned card' do
      expect {
        patch(:update, :card => card_attrs, :id => Fabricate(:card).id)
      }.to raise_error
    end

    context 'phrase card' do
      its('keys.size') { should eq(11) }
      its(:title) { should eq(card_attrs['title']) }
      its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
    end

    context 'paragraph card' do
      let(:card) {
        Fabricate('card/paragraph', :project => project, :board => board)}
      let(:card_attrs) { Fabricate.attributes_for('card/paragraph') }

      its('keys.size') { should eq(11) }
      its(:title) { should eq(card_attrs['title']) }
      its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
    end

    context 'number card' do
      let(:card) {
        Fabricate('card/number', :project => project, :board => board)}
      let(:card_attrs) { Fabricate.attributes_for('card/number') }

      its('keys.size') { should eq(11) }
      its(:title) { should eq(card_attrs['title']) }
      its(:content) { should eq(card_attrs['content'].round(3)) }
    end

    context 'timestamp card' do
      let(:card) {
        Fabricate('card/timestamp', :project => project, :board => board)}
      let(:card_attrs) { Fabricate.attributes_for('card/timestamp') }

      its('keys.size') { should eq(12) }
      its(:title) { should eq(card_attrs['title']) }
      its(:timestamp) { should eq(card_attrs['timestamp']) }
      its(:parsed_timestamp) {
        should eq(DateTime.parse(card_attrs['timestamp']).to_s(:pretty)) }
    end

    context 'interval card' do
      let(:card) {
        Fabricate('card/interval', :project => project, :board => board)}
      let(:card_attrs) { Fabricate.attributes_for('card/interval') }

      its('keys.size') { should eq(13) }
      its(:title) { should eq(card_attrs['title']) }
      its(:minimum) { should eq(card_attrs['minimum'].round(3)) }
      its(:maximum) { should eq(card_attrs['maximum'].round(3)) }
      its(:selected) { should eq(card_attrs['selected'].round(3)) }
    end
  end

  describe '#destroy' do
    let(:card) do
      Fabricate('card/phrase', :project => project, :board => board)
    end
    let(:card_id) { card.id }

    before { delete(:destroy, :id => card_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'card is not owned by current user' do
      let(:card_id) { rand(999...9999) }

      its('response.status') { should eq(400) }
    end
  end
end
