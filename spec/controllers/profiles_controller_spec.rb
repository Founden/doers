require 'spec_helper'

describe ProfilesController do
  let(:user) { Fabricate(:user) }

  describe '#show' do
    before do
      controller.stub(:current_account) { user }
      get(:show, :id => (user.id rescue 1))
    end

    it { should render_template(:show) }

    context 'as an authenticated visitor' do
      let(:user) { nil }

      it { should redirect_to(sign_in_path) }
    end
  end

  describe '#mine' do
    before do
      controller.stub(:current_account) { user }
      get(:mine)
    end

    it { should render_template(:mine) }

    context 'as an authenticated visitor' do
      let(:user) { nil }

      it { should redirect_to(sign_in_path) }
    end
  end

end
