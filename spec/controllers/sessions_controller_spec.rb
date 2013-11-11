require 'spec_helper'

describe SessionsController do

  describe '#after_successful_sign_in_url' do
    it 'returns after redirect location' do
      controller.send(:after_successful_sign_in_url).should eq(root_path)
    end
  end

  describe '#index' do
    before do
      get(:index)
    end

    it { should render_template(:index) }
  end

  describe '#create' do
    let(:params) {  }
    let!(:invitation) { }
    before { get(:create, params) unless example.metadata[:skip_before] }

    context 'for denied authentication' do
      let(:params) do
        {:error => 'access_denied', :identity => :oauth2,
         :provider => 'angel_list'}
      end

      it { should redirect_to(root_path) }
      its('flash.keys') { should include(:error) }
    end

    context 'for allowed authentication' do
      let(:params) do
        {:provider => :angel_list, :identity => :oauth2, :code => 'DUMMY_CODE'}
      end

      it { should redirect_to(root_path) }
      its('flash.keys') { should include(:notice) }

      context 'user' do
        subject(:user) { User.first }

        its('updated_at.to_i') { should eq(user.created_at.to_i) }

        context "after < #{Doers::Config.logout_after}", :skip_before => true do
          let(:user) { Fabricate(:user, :email => 'doer@geekcelerator.com') }

          before do
            @updated_at = user.updated_at
            freeze_at = @updated_at + Doers::Config.logout_after - 1.minutes
            Timecop.freeze(freeze_at) do
              get(:create, params)
            end
          end

          its('updated_at.to_i') { should eq(@updated_at.to_i) }
          its(:login_at) { should be_blank }
        end

        context "after #{Doers::Config.logout_after}", :skip_before => true do
          let(:user) { Fabricate(:user, :email => 'doer@geekcelerator.com') }

          before do
            @updated_at = user.updated_at
            freeze_at = @updated_at + Doers::Config.logout_after + 1.minutes
            Timecop.freeze(freeze_at) do
              get(:create, params)
            end
          end

          its('updated_at.to_i') { should eq(@updated_at.to_i) }
          its('reload.login_at.to_i') { should eq(@updated_at.to_i) }
        end
      end

      context '#after_successful_sign_in' do
        let(:invitation) {
          Fabricate(:board_invitation, :email => 'doer@geekcelerator.com') }
        let(:invitable) { invitation.invitable }

        it 'redirects to shared project' do
          anchor = '/%s/%d' % [invitable.class.name.downcase.pluralize,invitable.id]
          should redirect_to(root_path(:anchor => anchor))
        end
      end

    end
  end
end
