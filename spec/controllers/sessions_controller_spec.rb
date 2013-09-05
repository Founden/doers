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
    before { get(:create, params) }

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
    end
  end
end
