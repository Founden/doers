# Support for [Activity] generation on callbacks
module Activity::Support

  private

    # Generates activity slug based on current model and transaction type
    def activity_slug(postfix=nil)
      slug = 'update'
      slug = 'create' if self.transaction_record_state(:new_record)
      slug = 'destroy' if destroyed?
      [slug, self.class.name, postfix].join(' ').parameterize
    end

    # Generates activity attributes based on current model attributes
    def activity_params
      params = self.attributes.slice(
        'user_id', 'project_id', 'board_id', 'author_id', 'creator_id', 'title')
      params['slug'] = activity_slug
      params['trackable_id'] = self.id
      params['trackable_type'] = self.class.name
      params['user_id'] = params['author_id'] if params['user_id'].nil?
      params['trackable_title'] = params['title']
      if self.is_a?(Membership)
        params['user_id'] = params['creator_id']
        params['trackable_title'] = self.user.nicename
      end
      if self.is_a?(Invitation)
        params['trackable_title'] = self.email
        params['project_id'] =self.invitable_id if self.invitable.is_a?(Project)
        params['board_id'] = self.invitable_id if self.invitable.is_a?(Board)
      end
      params.except('author_id', 'creator_id', 'title')
    end

    # Activity generation hook
    def generate_activity(append_to_slug=nil)
      activity = self.activities.build(activity_params)
      activity.slug = activity_slug(append_to_slug) unless append_to_slug.nil?
      activity.save!
    end
end
