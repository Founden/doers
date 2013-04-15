require 'spec_helper'

describe GravatarHelper do
  let(:email) { Faker::Internet.email }
  let(:gravatar_opts) { {} }

  describe '#image_uri' do
    subject { helper.gravatar_uri(email, gravatar_opts) }

    before { Digest::MD5.stub(:hexdigest) { 'SOME_HASH' } }

    it { should match(/SOME_HASH/) }
    it { should match(/s=#{GravatarHelper::DEFAULT_OPTIONS[:size]}/) }

    context 'with a size' do
      let(:gravatar_opts) { {:size => 80} }

      it { should match(/s=80/) }
    end
  end

  describe '#image_tag' do
    subject { helper.gravatar_tag(email, gravatar_opts) }

    before { helper.stub(:gravatar_uri) { 'SOME_URI' } }

    it { should eq(image_tag(
      'SOME_URI', { :class => GravatarHelper::DEFAULT_OPTIONS[:class] } )) }

    context 'with a class name' do
      let(:gravatar_opts) { {:class => 'some_class'} }

      it { should eq(image_tag('SOME_URI', { :class => 'some_class' } )) }
    end
  end
end
