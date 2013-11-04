# Support for [Activity] notifications
module Activity::Notifier
  # Support for concerns
  extend ActiveSupport::Concern

  included do
    after_create :notify_channels
  end

  private

  # Generates a payload to be sent on notify
  # @return String comma delimited values of form `Class, ID`
  def payload
    self.class.connection.quote([self.class.name, self.id].join(','))
  end

  # Callback to notify one of the channels
  def notify_channels
    channels.each do |channel|
      self.class.connection.execute('NOTIFY %s, %s' % [channel, payload])
    end
  end

  # Returns a list of channels to be notified
  # @return Array with string values of form `['user_ID']`
  def channels
    if self.respond_to?(:project) and self.project
      self.project.collaborators.map { |collab| 'user_%d' % collab.id }
    else
      []
    end
  end
end
