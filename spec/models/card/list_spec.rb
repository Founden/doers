require 'spec_helper'

describe Card::List do
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject(:list_card) { Fabricate('card/list') }

    its(:content) { should_not be_blank }
    its(:items) { should_not be_empty }

    context '#items' do
      let(:label) { Faker::HTMLIpsum.body }
      let(:item) { {:label => label} }
      let(:items) { [item] }

      before{ list_card.update_attributes(:items => items) }

      subject { list_card.items }

      context 'on addition of an' do
        its(:size) { should eq(1) }
        its('first.keys.size') { should eq(2) }

        context 'item' do
          subject { OpenStruct.new(list_card.items.first) }

          its(:label) { should eq(Sanitize.clean(label)) }
          its(:checked) { should be_false }
        end
      end

      context 'on adding nothing' do
        let(:items) { '' }

        it { should be_empty }
      end

      context 'on adding an empty item' do
        let(:item) { '' }

        it { should be_empty }
      end

      context 'on adding a string' do
        let(:item) { Faker::HTMLIpsum.body }

        it { should be_empty }
      end
    end
  end
end
