# Default mailer for [User] actions
class UserMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email

  # Sends a confirmation email
  def confirmed(user)
    @user = user
    mail(:to => user.email,
         :subject => _('%s beta available from now.') % Doers::Config.app_name)
  end

  # Sends a startup import report to the project user
  def startup_imported(project)
    @project = project
    mail(:to => project.user.email, :subject => _('%s imported to %s.') % [
      project.title, Doers::Config.app_name])
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
end
