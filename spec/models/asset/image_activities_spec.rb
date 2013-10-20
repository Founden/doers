require 'spec_helper'

describe Asset::Image, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:image) { Fabricate('card/photo', :user => user).image }

  context '#activities' do
    subject(:activities) { image.assetable.activities }

    context 'on create' do
      its(:size) { should eq(2) }
    end

    context 'on update' do
      before { image.update_attributes(:description => Faker::Lorem.sentence) }

      subject { activities.first }

      it { activities.size.should eq(2) }

      its(:user) { should eq(image.user) }
      its(:project) { should eq(image.project) }
      its(:board) { should eq(image.board) }
      its(:card) { should eq(image.assetable) }
      its(:slug) { should match(/update-card.*asset.*/) }
    end

    context 'on delete' do
      before { image.destroy }

      its(:size) { should eq(2) }
    end
  end
end
