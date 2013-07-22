require 'spec_helper'

describe Api::V1::AssetsController do
  let(:user) { Fabricate(:user) }
  let(:project) { Fabricate(:project, :user => user) }
  let(:board) { Fabricate(:branched_board, :user => user, :project => project) }

  before do
    controller.stub(:current_account => user)
  end

  describe '#index' do
    let(:asset_ids) { [] }

    before { get(:index, :ids => asset_ids) }

    subject(:api_asset) { json_to_ostruct(response.body) }

    its('assets.size') { should eq(0) }

    context 'when queried ids are available' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }

      let(:asset_ids) { [card.image.id] }

      its('assets.size') { should eq(1) }
    end

    context 'when queried ids are not available' do
      let(:card) { Fabricate('card/photo') }

      let(:asset_ids) { [card.image.id] }

      its('assets.size') { should eq(0) }
    end
  end

  describe '#show' do
    let(:asset_id) { rand(99..999) }

    before { get(:show, :id => asset_id) }

    subject(:api_asset) { json_to_ostruct(response.body, :asset) }

    it { should be_nil }

    context 'for available assets' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:image) { card.image }
      let(:asset_id) { image.id }

      its('keys.size') { should eq(10) }
      its(:id) { should eq(image.id) }
      its(:description) { should eq(image.description) }
      its(:type) { should eq(image.type) }
      its(:attachment_url) { should eq(image.attachment.url) }
      its(:user_nicename) { should eq(image.user.nicename) }
      its(:user_id) { should eq(image.user.id) }
      its(:board_id) { should eq(image.board.id) }
      its(:project_id) { should eq(image.project.id) }
      its(:assetable_type) { should eq('Card') }
      its(:assetable_id) { should eq(card.id) }
    end
  end

  describe '#create' do
    before { post(:create, :asset => asset_attrs) }

    context 'with missing parameters' do
      let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload) }

      subject(:api_asset) { json_to_ostruct(response.body) }

      its('errors') { should_not be_blank }
    end

    context 'with valid parameters' do
      let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload,
        :user => user, :project => project, :board => board,
        :assetable_type => project.class, :assetable_id => project.id)
      }

      subject(:api_asset) { json_to_ostruct(response.body, :asset) }

      its('keys.size') { should eq(10) }
      its(:id) { should_not be_nil }
      its(:description) { should eq(asset_attrs[:description]) }
      its(:type) { should eq(asset_attrs[:type].to_s) }
      its(:attachment_url) { should_not be_empty }
      its(:user_nicename) { should eq(user.nicename) }
      its(:user_id) { should eq(user.id) }
      its(:board_id) { should eq(board.id) }
      its(:project_id) { should eq(project.id) }
      its(:assetable_type) { should eq(project.class.to_s) }
      its(:assetable_id) { should eq(project.id) }
    end
  end

  describe '#destroy' do
    let(:asset_id) { rand(99..999) }

    before { delete(:destroy, :id => asset_id) }

    its('response.status') { should eq(400) }
    its('response.body') { should be_blank }

    context 'for an available asset' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:asset_id) { card.image.id }

      its('response.status') { should eq(204) }
      its('response.body') { should be_blank }
    end
  end
end
