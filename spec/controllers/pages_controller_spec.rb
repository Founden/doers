require 'spec_helper'

describe PagesController do
  let(:user) { Fabricate(:user) }

  describe '#dashboard' do
    before do
      controller.stub(:current_account) { user }
      get(:dashboard)
    end

    it { should render_template(:dashboard) }

    context 'as an authenticated visitor' do
      let(:user) { nil }

      it { should redirect_to(sign_in_path) }
    end
  end

  describe '#waiting' do
    before do
      controller.stub(:current_account) { user }
      get(:waiting)
    end

    it { should render_template(:waiting) }

    context 'user updates interest' do
      let(:interest) { User::INTERESTS.values.sample }
      before do
        post(:waiting, :user => {:interest => interest})
      end

      it 'updates interest and renders template' do
        should render_template(:waiting)
        user.interest.should eq(interest.to_s)
      end
    end
  end

end
