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
    let(:newsletter_allowed) { ['1', '0'].sample }
    let(:user_id) { user.id }
    let(:current_account) { user }
    let(:avatar_upload) { Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/test.png'), 'image/png') }

    before do
      controller.stub(:current_account) { current_account }
      put(:update, :id => user_id, :user => {
        :email => email, :name => name, :confirmed => true,
        :newsletter_allowed => newsletter_allowed,
        :avatar => avatar_upload } )
    end

    it 'updates user profile' do
      should render_template(:mine)
      user.email.should eq(user.email)
      user.name.should eq(name)
      user.newsletter_allowed?.should eq(newsletter_allowed)
      user.avatar.should_not be_nil
    end

    context 'as a user updating a profile it does not own' do
      let(:user_id) { rand(10..20) }

      it 'updates own profile' do
        should render_template(:mine)
        user.name.should eq(name)
        user.newsletter_allowed?.should eq(newsletter_allowed)
      end
    end

    context 'as an administrative user' do
      let(:admin) { Fabricate(:admin) }
      let(:current_account) { admin }

      it 'updates any user profile' do
        should render_template(:edit)
        admin.name.should_not eq(name)

        user.reload
        user.name.should eq(name)
        user.email.should eq(user.email)
        user.confirmed?.should be_true
        user.newsletter_allowed?.should eq(newsletter_allowed)
      end
    end
  end

end
