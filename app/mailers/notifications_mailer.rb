# Mailer for [User] notifications
class NotificationsMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email

  def notify_discussions(membership)
  end

  def notify_collaborations(membership)
  end

  def notify_boards_topics(membership)
  end

  def notify_cards_alignments(membership)
  end

end
