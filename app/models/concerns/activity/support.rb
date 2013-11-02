# Support for [Activity] generation on callbacks
module Activity::Support
  # Support for concerns
  extend ActiveSupport::Concern

  included do
    # Activity slug postfix to be appended
    attr_accessor :activity_postfix
    # Activity author to be used
    attr_accessor :activity_author
  end

  # Target to use when generating activities
  def activity_owner
    self
  end


  private

    # Generates activity slug based on current model and transaction type
    def activity_slug(postfix=nil)
      slug = 'update'
      slug = 'create' if self.transaction_record_state(:new_record)
      slug = 'destroy' if destroyed?
      [slug, self.class.name.underscore.split('_'), postfix].compact.
        flatten.join(' ').parameterize
    end

    # Generates activity attributes based on current model attributes
    def activity_params
      params = self.attributes.slice('user_id', 'project_id', 'board_id',
        'topic_id', 'whiteboard_id', 'creator_id', 'title')
      params['slug'] = activity_slug
      if self.activity_author.respond_to?(:id) and self.activity_author.id
        params['user_id'] = self.activity_author.id
      end
      if self.is_a?(Membership)
        params['user_id'] = params['creator_id']
      end
      if self.is_a?(Invitation)
        params['project_id'] =self.invitable_id if self.invitable.is_a?(Project)
        params['board_id'] = self.invitable_id if self.invitable.is_a?(Board)
        params['invitation_email'] = self.email
      end
      if self.is_a?(Comment)
        params['comment_id'] = self.id
      end
      params.except('creator_id', 'title')
    end

    # Activity generation hook
    def generate_activity(append_to_slug=nil)
      activity = self.activity_owner.activities.build(activity_params)
      activity.slug = activity_slug(append_to_slug || activity_postfix)
      remove_previous_if_same_as(activity)
      activity.save!
    end

    # Callback checks for previous records on duplicated entries
    # Default time interval to check for is 10 minutes ago
    # TODO: Find a smarter way for this, it needs ~1s to work
    def remove_previous_if_same_as(current, time_diff=10.minutes)
      keys = %w(id created_at updated_at data)
      timing = (DateTime.now - time_diff)..DateTime.now
      current_attrs = current.attributes.except(*keys)
      self.activity_owner.activities.where(
        :created_at => timing, :slug => current.slug).each do |act|
          if act.attributes.except(*keys) == current_attrs
            act.destroy
          end
        end
    end
end
