require 'spec_helper'

describe Image, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:image) { Fabricate('card/photo', :user => user).image }

  context '#activities' do
    subject { image.assetable.activities }

    context 'on create' do
      its(:size) { should eq(2) }
    end

    context 'on update' do
      before { image.update_attributes(:description => Faker::Lorem.sentence) }

      its(:size) { should eq(2) }
      its('last.user') { should eq(image.user) }
      its('last.project') { should eq(image.project) }
      its('last.board') { should eq(image.board) }
      its('last.trackable') { should eq(image.assetable) }
      its('last.slug') { should match('update') }
      its('last.slug') { should match('image') }
    end

    context 'on delete' do
      before { image.destroy }

      subject { user.activities }

      its(:size) { should eq(3) }
    end
  end
end
