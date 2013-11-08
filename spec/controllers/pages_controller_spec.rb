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

  describe '#stats' do
    let(:format) { :html }
    let(:is_admin) { true }

    before do
      user.stub(:admin?) { is_admin }
      controller.stub(:current_account) { user }
      get(:stats, :format => format)
    end

    it { should render_template(:stats) }

    context 'when user is not admin' do
      let(:is_admin) { false }

      it { should redirect_to(root_path) }
    end

    context '.json' do
      let(:format) { :json }

      it 'renders a json' do
        stats_json = json_to_ostruct(response.body)
        stats_json.users.should_not be_empty
        stats_json.projects.should_not be_empty
        stats_json.boards.should_not be_empty
        stats_json.topics.should_not be_empty
        stats_json.suggestions.should_not be_empty
        stats_json.comments.should_not be_empty
        stats_json.activities.should_not be_empty
      end
    end
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
