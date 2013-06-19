require 'spec_helper'

describe ProfilesController do
  let(:user) { Fabricate(:user) }

  describe '#show' do
    before do
      controller.stub(:current_account) { user }
      get(:show, :id => (user.id))
    end

    it { should render_template(:show) }
  end

  describe '#edit' do
    let(:user_id) { user.id }

    before do
      controller.stub(:current_account) { user }
      get(:edit, :id => user_id)
    end

    it { should redirect_to(mine_profiles_path) }

    context 'as a user trying to edit a random user' do
      let(:another_user) { Fabricate(:user) }
      let(:user_id) { another_user.id }

      it { should redirect_to(mine_profiles_path) }
    end

    context 'as admin trying to edit a random user' do
      let(:user) { Fabricate(:admin) }
      let(:user_id) { Fabricate(:user).id }

      it { should render_template(:edit) }
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

  describe '#update' do
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:user_id) { user.id }

    before do
      controller.stub(:current_account) { user }
      put(:update, :id => user_id,
          :user => {:email => email, :name => name, :confirmed => true} )
    end

    it 'updates user profile' do
      should render_template(:show)
      user.email.should eq(user.email)
      user.name.should eq(name)
    end

    context 'as a user updating a profile it does not own' do
      let(:user_id) { rand(10..20) }

      it 'updates own profile' do
        should render_template(:show)
        user.name.should eq(name)
      end
    end

    context 'as an administrative user' do
      let(:admin) { Fabricate(:admin) }

      before do
        SuckerPunch::Queue.any_instance.should_receive(:perform)
        controller.stub(:current_account) { admin }
      end

      it 'updates any user profile' do
        should render_template(:show)
        admin.name.should_not eq(name)

        user.reload
        user.name.should eq(name)
        user.email.should eq(user.email)
        user.confirmed?.should be_true
      end
    end
  end

end
