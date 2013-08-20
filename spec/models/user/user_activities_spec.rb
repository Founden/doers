require 'spec_helper'

describe User, :use_truncation do
  let!(:user) { Fabricate(:user) }

  context '#activities' do
    subject { user.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(user) }
      its('first.trackable') { should eq(user) }
      its('first.slug') { should eq('create-user') }
    end

    context 'on update' do
      before { user.update_attributes(:name => Faker::Name.name) }

      its(:size) { should eq(1) }
    end

    context 'on delete' do
      before { user.destroy }

      its(:size) { should eq(1) }
    end
  end
end
