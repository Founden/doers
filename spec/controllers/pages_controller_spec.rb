require 'spec_helper'

describe PagesController do
  let(:user) { Fabricate(:user) }

  describe '#dashboard' do
    before do
      controller.stub(:current_account) { user }
      get(:dashboard)
    end

    it { should render_template(:dashboard) }

    context 'as an unconfirmed user' do
      let(:user) { Fabricate(:user, :confirmed => nil) }

      it { should redirect_to(waiting_pages_path) }
    end

    context 'as an authenticated visitor' do
      let(:user) { nil }

      it { should redirect_to(sign_in_path) }
    end
  end

  describe '#export' do
    before do
      controller.stub(:current_account) { user }
      get(:export)
    end

    it { should render_template(:export) }
  end

  describe '#download' do
    before do
      controller.stub(:current_account) { user }
      ImportJob.stub_chain(:new, :perform)
      Delayed::Job.should_receive(:enqueue).and_call_original
      get(:download)
    end

    it { should redirect_to(export_pages_path) }
  end

  describe '#waiting' do
    let(:user) { Fabricate(:user, :confirmed => nil) }

    before do
      controller.stub(:current_account) { user }
      get(:waiting)
    end

    it { should render_template(:waiting) }

    context 'user claims a code' do
      let(:code) { Doers::Config.promo_codes.sample }

      before do
        post(:waiting, :user => {:promo_code => code})
      end

      it 'updates user promo_code, confirmed attrs and redirects' do
        should redirect_to(root_path)
        user.confirmed?.should be_true
        user.promo_code.should eq(code)
      end

      context 'and is invalid' do
        let(:code) { Faker::Lorem.word }

        it 'shows the page again' do
          should render_template(:waiting)
          user.confirmed?.should be_false
          user.promo_code.should be_blank
        end
      end
    end
  end

end
