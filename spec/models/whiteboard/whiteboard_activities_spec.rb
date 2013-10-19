require 'spec_helper'

describe Whiteboard, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:whiteboard) { Fabricate(:whiteboard, :user => user) }

  context '#activities' do
    subject { whiteboard.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(whiteboard.user) }
      its('first.whiteboard') { should eq(whiteboard) }
      its('first.slug') { should eq('create-whiteboard') }
    end

    context 'on update' do
      before { whiteboard.update_attributes(:title => Faker::Company.name) }

      its(:size) { should eq(1) }
    end

    context 'on delete' do
      before { whiteboard.destroy }

      subject { user.activities }

      its('last.user') { should eq(user) }
      its('last.whiteboard_id') { should_not be_nil }
      its('last.slug') { should eq('destroy-whiteboard') }
    end
  end
end
