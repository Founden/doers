# DOERS [Activity] class
class Activity < ActiveRecord::Base
  # Include [Activity] notifications
  include Activity::Notifier

  # Some dynamic attributes
  store_accessor :data, :user_name, :project_title, :board_title
  store_accessor :data, :card_title, :topic_title, :invitation_email

  # Default scope: order by last update
  default_scope { order(:updated_at => :desc) }

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :whiteboard
  belongs_to :user
  belongs_to :card
  belongs_to :topic
  belongs_to :comment

  # Validations
  validates_presence_of :user
  validates_presence_of :slug

  # Callbacks
  after_validation do
    self.user_name = self.user.nicename if self.user
    self.project_title = self.project.title if self.project
    self.board_title = self.board.title if self.board
    self.topic_title = self.topic.title if self.topic
    self.card_title = self.card.title if self.card
  end
  after_commit :notify_project_collaborators, :on => :create


  private

  # If there's a project and it has collaborators, queue notifications
  def notify_project_collaborators
    if self.project and self.project.collaborators.count > 1
      self.project.collaborators.each do |collab|
        notify_project_collaborator(collab)
      end
    end
  end

  def notify_project_collaborator(collab)
    timing = notification_to_run_at(collab)
    return unless timing

    timing_type = collab.attributes[queue_type]
    now_type = Membership::TIMING.values.first
    asap_type = Membership::TIMING.values[1]
    maximum_offset = Doers::Config.notifications.offset
    job = collab.jobs.find_by(:queue => queue_type)

    if is_now = timing_type.eq?(now_type) or !job
      return NotificationsMailer.delay(
        :queue => queue_type, :run_at => timing, :membership => collab).
        send(queue_type, collab, self, :just_this => is_now)
    end

    # If there's already a job, check if it doesn't need rescheduling
    offset = job.run_at.to_i - self.created_at.to_i
    if offset < maximum_offset and timing_type.eq?(asap_type)
      job.update_attribute(:run_at, timing)
    end
  end

  def notification_to_run_at(collab)
    timing = collab.attributes[queue_type]
    case timing
    when 'now'
      1
    when 'asap'
      DateTime.now + Doers::Config.notifications.asap
    when 'daily'
      DateTime.now.at_end_of_day
    when 'weekly'
      DateTime.now.at_end_of_week
    else
      false
    end
  end

  def queue_type
    case self.slug
    when /comment|endorse/
      'notify_discussions'
    when /membership|invitation/
      'notify_collaborations'
    when /card|alignment/
      'notify_cards_alignments'
    when /board|topic/
      'notify_boards_topics'
    end
  end
end
