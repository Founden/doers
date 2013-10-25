require 'spec_helper'

feature 'Memberships', :js, :focus do
  background do
    sign_in_with_angel_list
  end

  context 'of a project' do
    given(:project) { Fabricate(:project, :user => User.first) }

    background do
      visit root_path(:anchor => '/projects/%d' % project.id)
    end

    context 'member is added' do
      scenario 'adds an user to memberships' do
        member = Fabricate(:user)
        expect(page).to have_css('.member-list .member-item', :count => 1)

        page.find('.member-item-add').click
        within('.member-add-form') do
          fill_in :email, :with => member.email
        end
        page.find('.add-member').click

        sleep(1)
        expect(page).to have_css('.member-list .member-item', :count => 2)
        expect(member.accepted_memberships.reload.count).to_not eq(0)
      end
    end

    context 'email is invited' do
      scenario 'sends an invitation' do
        email = Faker::Internet.email
        expect(page).to have_css('.member-list .member-item', :count => 1)

        page.find('.member-item-add').click
        within('.member-add-form') do
          fill_in :email, :with => email
        end
        page.find('.add-member').click

        expect(page).to have_css('.member-list .member-item', :count => 1)
        sleep(1)
        expect(Invitation.find_by(:email => email)).to_not be_nil
      end
    end
  end
end
