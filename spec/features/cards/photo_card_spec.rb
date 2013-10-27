require 'spec_helper'

feature 'Photo', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/photo', :user => User.first) }
    given(:topic) { card.topic }

    background do
      visit root_path(:anchor => '/topic/%d' % topic.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page).to have_field(:title, :with => card.title, :disabled => true)
      expect(page).to have_field(
        :content, :with => card.content, :disabled => true)

      page.find('.card-image')['src'].should have_content
        card.image.attachment.url.force_encoding('UTF-8')
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:content) { Faker::Lorem.sentence }
      given(:image_path) { Rails.root.join('spec/fixtures/test.png') }

      background do
        page.find('.edit-card').click
      end

      scenario 'can be saved' do
        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('content', :with => content)
          attach_file('image', image_path)
        end
        sleep(1)
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)
        expect(card.content).to eq(content)

        page.find('.card-image')['src'].should have_content
          card.image.attachment.url.force_encoding('UTF-8')
      end
    end
  end
end
