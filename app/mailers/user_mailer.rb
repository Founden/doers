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
end
