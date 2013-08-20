# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account
  # Include [Activity] generations support
  include Activity::Support

  INTERESTS = {
    _('Founder') => 'founder',
    _('Advisor') => 'advisor',
    _('Domain Expert') => 'expert',
    _('Running an Accelerator') => 'owner'
  }

  store_accessor :data, :confirmed, :interest, :company
  store_accessor :data, :importing, :newsletter_allowed

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :boards
  has_many :authored_boards, :foreign_key => :author_id, :class_name => Board
  has_many :cards
  has_many :comments, :dependent => :destroy
  has_many :assets, :dependent => :destroy
  has_many :images
  has_many :activities

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  after_commit :generate_activity, :on => :create
  after_commit :send_confirmation_email, :on => :update

  # Helper to generate the user name
  def nicename
    name || email
  end

  # Checks if user is confirmed
  def confirmed?
    !confirmed.blank?
  end

  # Allows newsletter to be sent?
  def newsletter_allowed?
    newsletter_allowed.nil? ? true : newsletter_allowed
  end

  # Check if user can administrate things
  def admin?
    !Doers::Config.admin_regex.match(email).blank?
  end

  # Authorizes current user with `action` on `target`, where
  # @param action [String] has one of the `read` or `writes` values
  # @param target [Object] is a model or an array of models to apply `action`
  # @return true if action is doable or false if not
  def can?(action, target, options=nil)
    options ||= { :raise_error => true }

    return true if !target or (target.respond_to?(:empty?) and target.empty?)

    klass = target.respond_to?(:model) ? target.model : target.class

    can = case klass.to_s
    when /Asset|Image|Logo/
      !assets_to(action).where(:id => target).empty?
    when 'Board'
      !boards_to(action).where(:id => target).empty?
    when /Card/
      !cards_to(action).where(:id => target).empty?
    else
      # Just check if we are the owners
      target.respond_to?(:user_id) and target.user_id == self.id
    end

    if !can and options[:raise_error]
      raise ActiveRecord::RecordNotFound
    else
      can
    end
  end

  # Available assets for user, `action` can be :read or :write
  def assets_to(action)
    table = Asset.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User created its board
        table[:board_id].in(self.board_ids).or(
          # User branched the board
          table[:board_id].in(self.authored_boards.pluck('id'))
        )
      ).or(
        # User project has it
        table[:project_id].in(self.project_ids)
        # TODO: Is part of the project
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:board_id].in(Board.public.pluck('id'))
      )
    end

    Asset.where(query)
  end

  # Available boards for user, `action` can be :read or :write
  def boards_to(action)
    table = Board.arel_table

    query =
      # User is the author
      table[:author_id].eq(self.id).or(
        # User branched a board
        table[:user_id].eq(self.id)
      ).or(
        # Owns the project
        table[:project_id].in(self.project_ids)
        # TODO: Is part of the project
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:status].eq(Board::STATES.last)
      )
    end

    Board.where(query)
  end

  # Available cards for user, `action` can be :read or :write
  def cards_to(action)
    table = Card.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User created its board
        table[:board_id].in(self.board_ids).or(
          # User branched the board
          table[:board_id].in(self.authored_boards.pluck('id'))
        )
      ).or(
        # User project has it
        table[:project_id].in(self.project_ids)
        # TODO: Is part of the project
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:board_id].in(Board.public.pluck('id'))
      )
    end

    Card.where(query)
  end

  private

  # Create a job to send the confirmation email on validation
  def send_confirmation_email
    _data = previous_changes[:data]
    # It's either a hash or an array of changes
    _data = _data.last if _data.respond_to?(:last)

    if !_data.blank? and data[:confirmed].to_i > 0
      UserMailer.delay.confirmed(self)
    end
  end

end
