require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  context 'instance class' do
    subject { user }

    it { should be_valid }
    its(:email) { should_not be_empty }
    its(:name) { should_not be_empty }

    context 'on duplicates' do
      subject { Fabricate.build(:user, :email => user.email) }

      it { should_not be_valid }
    end
  end
end
