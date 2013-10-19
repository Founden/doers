# Default mailer for [User] actions
class UserMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email

  # Sends a startup import report to the project user
  def startup_imported(project)
    @project = project
    mail(:to => project.user.email, :subject => _('%s imported to %s.') % [
      project.title, Doers::Config.app_name])
  end

  # Sends a notice to the invitation creator
  def invitation_claimed(invitation, user)
    @invitation = invitation
    @user = user
    mail(:to => invitation.user.email, :subject => _('%s joined %s.') % [
      @user.nicename, Doers::Config.app_name])
  end

  # Sends an invitation for a project/board or just to join
  def invite(invitation)
    @invitable = invitation.invitable
    @user = invitation.user
    # TODO: UPDATE the registration URL
    @registration_url = root_url

    view = 'invite'
    # invite_project or invite_board if available
    view += ('_%s' % invitation.invitable_type.parameterize) if @invitable

    title = @invitable.nil? ? Doers::Config.app_name : @invitable.title
    subject = _('%s invites you to work on %s.') % [invitation.user.name, title]

    mail(:to => invitation.email, :subject => subject, :template_name => view)
  end

  # Sends a notification about newly created membership user is part of
  def membership_notification(membership)
    @dashboard_url = root_url
    @user = membership.user
    @creator = membership.creator
    @target = membership.whiteboard || membership.board || membership.project
    mail(:to => @user.email, :subject => _('%s added you to %s on %s.') % [
      @creator.nicename, @target.title, Doers::Config.app_name])
  end

  # Sends an email with exported data
  def export_data(user, zip_path)
    @user = user
    attachments['doers_boards.zip'] = File.read(zip_path)
    mail(:to => user.email, :subject => _('Your %s exported data.') % [
      Doers::Config.app_name])
  end
end
