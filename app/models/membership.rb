# DOERS [Membership] class
class Membership < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Available values for `notify_*` attributes
  TIMING = {
    _('Immediately')         => 'now',
    _('As soon as possible') => 'asap',
    _('Daily')               => 'daily',
    _('Weekly')              => 'weekly',
    _('Never')               => false
  }

  store_accessor :data, :notify_discussions, :notify_collaborations
  store_accessor :data, :notify_boards_topics, :notify_cards_alignments

  # Relationships
  belongs_to :creator, :class_name => User
  belongs_to :user
  belongs_to :board
  belongs_to :whiteboard
  belongs_to :project
  has_one :invitation, :dependent => :destroy
  has_many :delayed_jobs, :dependent => :destroy, :class_name => Delayed::Job

  # Validations
  validates_presence_of :user, :creator
  validates_inclusion_of :notify_discussions, :in => TIMING.values
  validates_inclusion_of :notify_collaborations, :in => TIMING.values
  validates_inclusion_of :notify_boards_topics, :in => TIMING.values
  validates_inclusion_of :notify_cards_alignments, :in => TIMING.values

  # Callbacks
  after_commit :notify_member, :on => :create
  after_initialize do
    self.notify_discussions ||= TIMING.values.first
    self.notify_collaborations ||= TIMING.values.first
    self.notify_boards_topics ||= TIMING.values.first
    self.notify_cards_alignments ||= TIMING.values.first
  end

  private

    # Sends an email with details about the new membership
    def notify_member
      UserMailer.delay.membership_notification(self)
    end
end
