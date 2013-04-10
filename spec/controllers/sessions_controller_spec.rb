require 'spec_helper'

describe SessionsController do

  describe 'private methods' do
    let(:user_attr) { Fabricate.build(:user, :id => 1) }
    before do
      controller.should_receive(:current_user).and_return(user_attr)
    end

    it 'returns after redirect location' do
      controller.send(:after_successful_sign_in_url_default).should eq(
        profile_path(user_attr))
    end

  end

  describe '#index' do
    before do
      get(:index)
    end

    it { should render_template(:index) }
  end

end
