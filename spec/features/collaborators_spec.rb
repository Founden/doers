require 'spec_helper'

feature 'Collaborators', :js do

  background do
    sign_in_with_angel_list
  end

  context 'from an existing project' do
    given(:user) { User.first }

    background do
      Fabricate(:project_with_memberships, :user => user)
      visit root_path(:anchor => '/memberships')
    end

    scenario 'are shown' do
      expect(page).to have_css('.membership-project', :count => user.projects.count)
      user.projects.each do |project|
        expect(page).to have_content(project.title)
        expect(page).to have_css(
          '#project-%s .membership-user' % project.id, :count => project.memberships.count)
      end
    end

    scenario 'and can be removed' do
      project = user.projects.first
      members_selector = '#project-%d .membership-user-remove' % project.id
      members_count = project.members.count

      page.all(members_selector).first.click

      expect(page).to have_css(members_selector, :count => members_count - 1)
      sleep(1)
      expect(project.members.reload.count).to eq(members_count - 1)
    end

    scenario 'can be invited' do
      email = Faker::Internet.email

      within('.membership-invitee-form') do
        fill_in :email, :with => email
      end
      page.find('.membership-invitee-form .button').click

      expect(page).to have_css('.membership-invitee', :count => 1)
      expect(page).to have_content(email)
      sleep(1)
      expect(Invitation.find_by(:email => email)).to_not be_nil
    end
  end
end
