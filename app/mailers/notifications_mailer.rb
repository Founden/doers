# Mailer for [User] notifications
class NotificationsMailer < ActionMailer::Base
  default :from => Doers::Config.default_email,
    :return_path => Doers::Config.contact_email

  # Handles discussion changes email
  def notify_discussions(membership, activity, opts)
    @slug_types = %w(%comment% %endorse%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ? prepare_activities(activity) : [activity]
    subject = _('%s recent comments and endorsements on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles collaboration changes email
  def notify_collaborations(membership, activity, opts)
    @slug_types = %w(%membership% %invitation%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ? prepare_activities(activity) : [activity]
    subject = _('%s recent invitations and members on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles board and topic changes email
  def notify_boards_topics(membership, activity, opts)
    @slug_types = %w(%card% %alignment%)
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ? prepare_activities(activity) : [activity]
    subject = _('%s recent board and topic changes on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Handles alignment and suggestion changes email
  def notify_cards_alignments(membership, activity, opts)
    @slug_types = %w('%board% %topic')
    @user = membership.user
    @project = membership.project
    @activities = opts['just_this'] ? prepare_activities(activity) : [activity]
    subject = _('%s topic alignments and suggestions on %s.') % [
      @project.title, Doers::Config.app_name]
    mail(:to => @user.email, :subject => subject)
  end

  def prepare_activities(activity)
    timing = activity.created_at..DateTime.now
    project_ids = @user.projects.pluck('id')
    Activity.where(:project_id => project_ids, :created_at => timing).
      where(Activity.arel_table[:slug].matches_any(@slug_types))
  end

end
