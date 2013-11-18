# Mailer for [User] notifications
class NotificationsMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email,
    :css => 'mail'
  layout 'notification'

  # Handles discussion changes email
  def notify_discussions(membership, activity, opts)
    slug_types = %w(%comment% %endorse%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ?
      [activity] : activity.search_for_project(@user, slug_types)
    @usernames = @activities.map(&:user_name).uniq.join(', ')
    subject = _('%s recent comments and endorsements on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles collaboration changes email
  def notify_collaborations(membership, activity, opts)
    slug_types = %w(%membership% %invitation%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ?
      [activity] : activity.search_for_project(@user, slug_types)
    @usernames = @activities.map { |act|
      act.member_name || act.invitation_email }.uniq.join(', ')
    subject = _('%s recent invitations and members on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles board and topic changes email
  def notify_boards_topics(membership, activity, opts)
    slug_types = %w(%board% %topic)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ?
      [activity] : activity.search_for_project(@user, slug_types)
    @usernames = @activities.map(&:user_name).uniq.join(', ')
    subject = _('%s recent board and topic changes on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles alignment and suggestion changes email
  def notify_cards_alignments(membership, activity, opts)
    slug_types = %w(%card% %alignment%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ?
      [activity] : activity.search_for_project(@user, slug_types)
    @usernames = @activities.map(&:user_name).uniq.join(', ')
    subject = _('%s topic alignments and suggestions on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end
end
