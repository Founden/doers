# Support for [Activity] generation on callbacks
module Activity::Support
  extend ActiveSupport::Concern

  private

    # Generates activity slug based on current model and transaction type
    def activity_slug
      slug = 'update'
      slug = 'create' if self.transaction_record_state(:new_record)
      slug = 'destroy' if destroyed?
      (slug + ' ' + self.class.name).parameterize
    end

    # Generates activity attributes based on current model attributes
    def activity_params
      params = self.attributes.slice(
        'user_id', 'project_id', 'board_id', 'author_id')
      params[:slug] = activity_slug
      params[:trackable_id] = self.id
      params[:trackable_type] = self.class.name

      params['user_id'] = params['author_id'] if params['user_id'].nil?
      params.delete('author_id')
      params
    end

    # Activity generation hook
    def generate_activity
      activity = self.activities.build(activity_params)
      activity.save!
    end
end
