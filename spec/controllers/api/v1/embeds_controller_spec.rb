require 'spec_helper'

describe Api::V1::EmbedsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:url) { Faker::Internet.http_url }
    let(:known_url) { false }
    let(:oembed_response) { }

    before do
      if oembed_response
        Oembedr.should_receive(:known_service?).and_return(true)
        Oembedr.should_receive(:fetch).and_return(oembed_response)
      else
        Oembedr.should_receive(:known_service?).and_return(false)
      end
      get(:index, :url => url)
    end

    context 'url is not trusted' do
      its('response.status') { should eq(400) }
    end

    context 'url is trusted' do
      let(:attrs) do
        {:tile => Faker::Lorem.sentence, :type => %w(video rich).sample}
      end
      let(:oembed_response) { OpenStruct.new(:body => attrs) }

      its('response.status') { should eq(200) }

      context 'and response' do
        subject(:api_embeds) { json_to_ostruct(response.body) }

        its('embeds.size') { should eq(1) }

        context 'first embed' do
          subject { OpenStruct.new api_embeds.embeds.first }

          its(:title) { should eq(attrs[:title]) }
          its(:embed_type) { should eq(attrs[:type]) }
        end
      end
    end

  end
end
