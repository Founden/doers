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

end
