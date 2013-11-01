require 'spec_helper'

feature 'Memberships', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'of a project' do

    background do
      visit root_path(:anchor => '/projects/%d' % project.id)
    end

    context 'member is added' do
      given(:membership) { Fabricate(:project_membership, :user => User.first) }
      given(:project) { membership.project }

      scenario 'adds an user to memberships' do
        member = Fabricate(:user)
        expect(page).to have_css('.project-member', :count => 1)

        page.find('.project-invitee-add').click
        within('.project-invitee-form') do
          fill_in :email, :with => member.email
        end
        page.find('.invite-member').click

        sleep(1)
        expect(page).to have_css('.project-member', :count => 2)
        expect(member.accepted_memberships.reload.count).to_not eq(0)
      end

      scenario 'member can be removed' do
        expect(page).to have_css('.project-member', :count => 1)

        page.find('.project-member').hover
        page.find('.project-member-remove').click

        sleep(1)
        expect(page).to have_css('.project-member', :count => 0)
        expect(project.members.count).to eq(0)
      end
    end

    context 'email is invited' do
      given(:invitation) { Fabricate(:project_invitation, :user => User.first) }
      given(:project) { invitation.invitable }

      scenario 'sends an invitation' do

        email = Faker::Internet.email
        expect(page).to have_css('.project-invitee', :count => 1)

        page.find('.project-invitee-add').click
        within('.project-invitee-form') do
          fill_in :email, :with => email
        end
        page.find('.invite-member').click

        expect(page).to have_css('.project-invitee', :count => 2)
        sleep(1)
        expect(Invitation.find_by(:email => email)).to_not be_nil
      end

      scenario 'invitation can be removed' do
        expect(page).to have_css('.project-invitee', :count => 1)

        page.find('.remove-invitee').click

        sleep(1)
        expect(page).to have_css('.project-invitee', :count => 0)
        expect(project.invitations.count).to eq(0)
      end
    end

  end
end
