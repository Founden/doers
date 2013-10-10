require 'spec_helper'

describe AvatarHelper do
  let(:user) { Fabricate(:user) }
  let(:email) { user.email }
  let(:avatar_opts) { {} }

  describe '#avatar_uri' do
    subject { helper.avatar_uri(user, avatar_opts) }

    context 'when a user has no avatar' do
      let(:fake_gravatar) { rand(1000).to_s }
      before do
        helper.should_receive(:gravatar_uri).with(
          user.email, avatar_opts).and_return(fake_gravatar)
      end

      it { should eq(fake_gravatar) }
    end

    context 'when a user has an avatar' do
      let(:avatar) { Fabricate(:avatar, :user => Fabricate(:user)) }
      let(:user) { avatar.user }

      it { should eq(avatar.attachment.url(:thumb)) }
    end

  end

  describe '#gravatar_uri' do
    subject { helper.gravatar_uri(email, avatar_opts) }

    before { Digest::MD5.stub(:hexdigest) { 'SOME_HASH' } }

    it { should match(/SOME_HASH/) }
    it { should match(/s=#{AvatarHelper::DEFAULT_OPTIONS[:size]}/) }

    context 'with a size' do
      let(:avatar_opts) { {:size => 80} }

      it { should match(/s=80/) }
    end
  end

  describe '#avatar_tag' do
    let(:tag_class) { AvatarHelper::DEFAULT_OPTIONS[:class] }
    subject { helper.avatar_tag(user, avatar_opts) }

    context 'when user has no avatar uploaded' do
      before { helper.stub(:gravatar_uri) { 'SOME_URI' } }

      it { should eq(image_tag('SOME_URI', { :class => tag_class } )) }

      context 'with a class name' do
        let(:avatar_opts) { {:class => 'some_class'} }

        it { should eq(image_tag('SOME_URI', { :class => 'some_class' } )) }
      end
    end

    context 'when user has an avatar' do
      let!(:avatar) { Fabricate(:avatar, :user => user) }

      it { should eq(
        image_tag(avatar.attachment.url(:thumb), { :class => tag_class } )) }
    end

  end
end
