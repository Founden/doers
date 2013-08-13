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
    let(:card_id) { rand(99..999) }

    it 'wont find unavailable cards' do
      expect {
        get(:show, :id => card_id)
      }.to raise_error
    end

    context 'for available cards' do
      let(:card) {
        Fabricate('card/phrase', :project => project, :board => board) }
      let(:card_id) { card.id }

      before { get(:show, :id => card_id) }

      subject(:api_card) { json_to_ostruct(response.body, :card) }

      its(:id) { should eq(card.id) }
      its(:title) { should eq(card.title) }
      its(:title_hint) { should eq(card.title_hint) }
      its(:question) { should eq(card.question) }
      its(:help) { should eq(card.help) }
      its(:position) { should eq(card.position) }
      its(:type) { should eq(card.type.to_s.demodulize) }
      its(:updated_at) { should_not be_nil }
      its(:user_id) { should eq(card.user.id) }
      its(:user_nicename) { should eq(card.user.nicename) }
      its(:project_id) { should eq(card.project.id) }
      its(:board_id) { should eq(card.board.id) }

      context 'phrase card keys' do
        its('keys.size') { should eq(14) }
        its(:content) { should eq(card.content) }
      end

      context 'paragraph card keys' do
        let(:card) {
          Fabricate('card/paragraph', :project => project, :board => board) }

        its('keys.size') { should eq(14) }
        its(:content) { should eq(card.content) }
      end

      context 'number card keys' do
        let(:card) {
          Fabricate('card/number', :project => project, :board => board) }

        its('keys.size') { should eq(15) }
        its(:number) { should eq(card.number) }
        its(:content) { should eq(card.content) }
      end

      context 'timestamp card keys' do
        let(:card) {
          Fabricate('card/timestamp', :project => project, :board => board) }

        its('keys.size') { should eq(14) }
        its(:content) { should eq(card.content) }
      end

      context 'interval card keys' do
        let(:card) {
          Fabricate('card/interval', :project => project, :board => board) }

        its('keys.size') { should eq(17) }
        its(:minimum) { should eq(card.minimum) }
        its(:maximum) { should eq(card.maximum) }
        its(:selected) { should eq(card.selected) }
      end

      context 'book card keys' do
        let(:card) {
          Fabricate('card/book', :project => project, :board => board) }

        its('keys.size') { should eq(18) }
        its(:url) { should eq(card.url) }
        its(:book_title) { should eq(card.book_title) }
        its(:book_authors) { should eq(card.book_authors) }
        its(:image_id) { should eq(card.image.id) }
      end

      context 'photo card keys' do
        let(:card) {
          Fabricate('card/photo', :project => project, :board => board) }

        its('keys.size') { should eq(15) }
        its(:image_id) { should eq(card.image.id) }
      end

      context 'video card keys' do
        let(:card) {
          Fabricate('card/video', :project => project, :board => board) }

        its('keys.size') { should eq(17) }
        its(:image_id) { should eq(card.image.id) }
        its(:video_id) { should eq(card.video_id) }
        its(:provider) { should eq(card.provider) }
      end

      context 'map card keys' do
        let(:card) {
          Fabricate('card/map', :project => project, :board => board) }

        its('keys.size') { should eq(16) }
        its(:latitude) { should eq(card.latitude.to_f) }
        its(:longitude) { should eq(card.longitude.to_f) }
        its(:content) { should eq(card.content) }
      end

      context 'link card keys' do
        let(:card) {
          Fabricate('card/link', :project => project, :board => board) }

        its('keys.size') { should eq(15) }
        its(:url) { should eq(card.url) }
        its(:content) { should eq(card.content) }
      end

      context 'list card' do
        let(:card) {
          Fabricate('card/list', :project => project, :board => board) }

        its('keys.size') { should eq(15) }
        its('items.size') { should eq(card.items.size) }
        its(:content) { should eq(card.content) }

        context 'items.first' do
          let(:item) { card.items.first }

          subject{ OpenStruct.new(item) }

          its(:label) { should eq(item['label']) }
          its(:checked) { should eq(item['checked']) }
        end
      end
    end
  end

  describe '#create' do
    let(:card_attrs) {}

    before { post(:create, :card => card_attrs) }

    context 'with wrong parameters' do
      context 'on type' do
        let(:card_attrs) { Fabricate.attributes_for(
          'card/phrase', :user => user, :board => board) }

        its('response.status') { should eq(400) }
        its('response.body') { should match('errors') }
      end

      context 'on attributes' do
        let(:card_attrs) { Fabricate.attributes_for(
          'card/phrase', :user => user, :type => 'Phrase', :board => nil) }

        its('response.status') { should eq(400) }
        its('response.body') { should match('errors') }
      end

      context 'on a not owned board_id' do
        let(:card_attrs) { Fabricate.attributes_for(
          'card/phrase', :user => user, :type => 'Phrase') }

        its('response.status') { should eq(400) }
        its('response.body') { should match('errors') }
      end
    end

    context 'with valid parameters' do
      let(:card_attrs) { Fabricate.attributes_for(
        'card/phrase', :user => user, :board => board, :type => 'Phrase') }

      subject(:api_card) { json_to_ostruct(response.body, :card) }

      its('keys.size') { should eq(14) }
      its(:id) { should_not be_blank }
      its(:title) { should eq(card_attrs[:title]) }
      its(:title_hint) { should eq(card_attrs[:title_hint]) }
      its(:question) { should eq(card_attrs[:question]) }
      its(:help) { should eq(card_attrs[:help]) }
      its(:position) { should_not be_nil }
      its(:style) { should_not be_nil }
      its(:type) { should eq(card_attrs[:type]) }
      its(:updated_at) { should_not be_blank }
      its(:user_id) { should eq(user.id) }
      its(:user_nicename) { should eq(user.nicename) }
      its(:project_id) { should eq(card_attrs[:project]) }
      its(:board_id) { should eq(board.id) }
      its(:content) { should eq(card_attrs[:content]) }
    end
  end

  describe '#update' do
    let(:card_id) { rand(99..999) }

    it 'does nothing to a not owned card' do
      expect {
        patch(:update, :card => {:title => ''}, :id => card_id)
      }.to raise_error
    end

    context 'for available cards' do
      let(:card_id) { card.id }

      before { patch(:update, :id => card_id, :card => card_attrs) }

      subject(:api_card) { json_to_ostruct(response.body, :card) }

      context 'user is updated to latest user who did changes' do
        let(:card_attrs) { Fabricate.attributes_for('card/phrase') }
        let(:card) { Fabricate(
          'card/phrase', :project => project, :board => board) }

        subject(:api_card) { json_to_ostruct(response.body, :card) }

        its(:user_id) { should eq(user.id) }
        its(:user_id) { should_not eq(card.id) }
      end

      context 'phrase card' do
        let(:card_attrs) { Fabricate.attributes_for('card/phrase') }
        let(:card) {
          Fabricate('card/phrase', :project => project, :board => board)}

        its('keys.size') { should eq(14) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
      end

      context 'paragraph card' do
        let(:card) {
          Fabricate('card/paragraph', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/paragraph') }

        its('keys.size') { should eq(14) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
      end

      context 'number card' do
        let(:card) {
          Fabricate('card/number', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/number') }

        its('keys.size') { should eq(15) }
        its(:title) { should eq(card_attrs['title']) }
        its(:number) { should eq(card_attrs['number']) }
        its(:content) { should eq(card_attrs['content']) }
      end

      context 'timestamp card' do
        let(:card) {
          Fabricate('card/timestamp', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/timestamp') }

        its('keys.size') { should eq(14) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(card_attrs['content']) }
      end

      context 'interval card' do
        let(:card) {
          Fabricate('card/interval', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/interval') }

        its('keys.size') { should eq(17) }
        its(:title) { should eq(card_attrs['title']) }
        its(:minimum) { should eq(card_attrs['minimum']) }
        its(:maximum) { should eq(card_attrs['maximum']) }
        its(:selected) { should eq(card_attrs['selected']) }
      end

      context 'photo card' do
        let(:card) {
          Fabricate('card/photo', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/photo') }

        its('keys.size') { should eq(15) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
        its(:image_id) { should eq(card.image.id) }
      end

      context 'video card' do
        let(:card) {
          Fabricate('card/video', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/video') }

        its('keys.size') { should eq(17) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
        its(:video_id) { should eq(card_attrs[:video_id]) }
        its(:provider) { should eq(card_attrs[:provider]) }
        its(:image_id) { should eq(card.image.id) }
      end

      context 'link card' do
        let(:card) {
          Fabricate('card/link', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/link') }

        its('keys.size') { should eq(15) }
        its(:title) { should eq(card_attrs['title']) }
        its(:url) { should eq(card_attrs['url']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
      end

      context 'map card' do
        let(:card) {
          Fabricate('card/map', :project => project, :board => board)}
        let(:card_attrs) { Fabricate.attributes_for('card/map') }

        its('keys.size') { should eq(16) }
        its(:title) { should eq(card_attrs['title']) }
        its(:content) { should eq(Sanitize.clean(card_attrs['content'])) }
        its(:latitude) { should eq(card_attrs['latitude']) }
        its(:longitude) { should eq(card_attrs['longitude']) }
      end

      context 'list card' do
        let(:card) {
          Fabricate('card/list', :project => project, :board => board) }
        let(:card_attrs) { Fabricate.attributes_for('card/list') }

        its('keys.size') { should eq(15) }
        its('items.size') { should eq(card.items.size) }
        its(:content) { should eq(card_attrs['content']) }

        context 'items.first' do
          let(:item) { card_attrs['items'].first }

          subject{ OpenStruct.new(api_card.items.first) }

          its(:label) { should eq(item['label']) }
          its(:checked) { should eq(item['checked']) }
        end
      end
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
