require 'spec_helper'

feature 'Memberships', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  shared_examples 'member is added' do
    scenario 'adds an user to memberships' do
      member = Fabricate(:user)
      expect(page).to have_css('.member-list .member-item', :count => 0)

      page.find('.member-item-add').click
      within('.member-item-add-form') do
        fill_in :email, :with => member.email
      end
      page.find('.member-item-add-form .button').click
      page.find('.member-item-add.active').click

      sleep(1)
      expect(page).to have_css('.member-list .member-item', :count => 1)
      expect(member.accepted_memberships.reload.count).to_not eq(0)
    end
  end

  shared_examples 'email is invited' do
    scenario 'sends an invitation' do
      email = Faker::Internet.email
      expect(page).to have_css('.member-list .member-item', :count => 0)

      page.find('.member-item-add').click
      within('.member-item-add-form') do
        fill_in :email, :with => email
      end
      page.find('.member-item-add-form .button').click
      page.find('.member-item-add.active').click

      expect(page).to have_css('.member-list .member-item', :count => 0)
      sleep(1)
      expect(Invitation.find_by(:email => email)).to_not be_nil
    end
  end

  context 'in a page' do
    given(:page_path) {}

    background do
      visit page_path
    end

    context 'of a build board' do
      given(:board) do
        Fabricate(:public_board, :user => User.first)
      end
      given(:page_path) do
        root_path(:anchor => '/boards/%d/build' % board.id)
      end

      include_examples 'member is added'
      include_examples 'email is invited'
    end

    context 'of a project' do
      given(:project) { Fabricate(:project, :user => User.first) }
      given(:page_path) do
        root_path(:anchor => '/projects/%d' % project.id)
      end

      include_examples 'member is added'
      include_examples 'email is invited'
    end
  end
end
