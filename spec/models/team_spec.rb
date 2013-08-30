require 'spec_helper'

describe Team do
  it { should have_one(:banner).dependent(:destroy) }
  it { should have_many(:boards) }
  it { should have_many(:users).through(:boards) }

  %w(website angel_list).each do |attr|
    it { should allow_value(Faker::Internet.uri(:http)).for(attr) }
    it { should allow_value(Faker::Internet.uri(:https)).for(attr) }
    it { should_not allow_value(Faker::Lorem.sentence).for(attr) }
  end

  context 'instance' do
    subject(:team) { Fabricate(:team) }

    context 'sanitizes' do
      let(:content) { Faker::HTMLIpsum.body[0..250] }

      context '#title' do
        before { team.update_attributes(:title => content) }

        its(:title) { should eq(Sanitize.clean(content)) }
        its(:slug) { should_not eq(team.title.parameterize) }
      end

      context '#description' do
        before { team.update_attributes(:description => content) }

        its(:description) { should eq(Sanitize.clean(content)) }
      end

      context '#slug' do
        subject(:team) { Fabricate(:team, :title => content) }

        its(:slug) { should eq(team.title.parameterize) }

        context 'on update' do
          let(:new_content) { Faker::HTMLIpsum.body[0..250] }
          before { team.update_attributes(:slug => new_content) }

          its(:slug) { should eq(Sanitize.clean(new_content).parameterize) }
        end
      end
    end
  end
end
