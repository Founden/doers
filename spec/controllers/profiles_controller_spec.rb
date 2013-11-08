require 'spec_helper'

describe ProfilesController do
  let(:user) { Fabricate(:user) }

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
    let(:current_account) { user }
    let(:avatar_upload) { Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/test.png'), 'image/png') }

    before do
      controller.stub(:current_account) { current_account }
      put(:update, :id => :mine, :user => {
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
  end

  describe '#notifications' do
    let(:membership) { Fabricate(:project_membership) }
    let(:user) { membership.user }

    before do
      controller.stub(:current_account) { user }
      get(:notifications, :profile_id => 'mine')
    end

    it { should render_template(:notifications) }

    context 'on notification request' do
      let(:value) { Membership::TIMING.values.sample }
      let(:option) { 'notify_discussions' }
      let(:memb_id) { membership.id }

      before do
        patch(:notifications, :membership => {option => value, :id => memb_id},
              :profile_id => 'mine')
      end

      it 'updates membership notification option' do
        should render_template(:notifications)
        membership.reload.send(option).should eq(value)
      end

      context 'on random membership request' do
        let(:memb_id) { Fabricate(:project_membership).id }

        it 'wont update membership notification option' do
          should render_template(:notifications)
          membership.reload.send(option).should_not eq(value)
        end
      end
    end
  end

end
