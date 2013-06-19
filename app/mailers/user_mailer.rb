# Default mailer for [User] actions
class UserMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email

  # Sends a welcome email
  def welcome(user)
    @user = user
    mail(:to => user.email, :subject => _('Hello from DOERS.'))
  end

  # Sends a confirmation email
  def confirmed(user)
    @user = user
    mail(:to => user.email, :subject => _('DOERS beta available from now.'))
  end
end
