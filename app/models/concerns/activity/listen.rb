# Support for [Activity] listening
module Activity::Listen
  # Support for concerns
  extend ActiveSupport::Concern

  # Listens to the channel for notifications and yields if any
  def on_notification
    self.class.connection.execute('LISTEN %s' % channel)
    loop do
      self.class.connection.raw_connection.wait_for_notify do |ev, pid, payload|
        if notification = parse_payload(payload)
           yield notification
        end
      end
    end
  ensure
    self.class.connection.execute('UNLISTEN %s' % channel)
  end

  private

  # Handles payload
  # @param String payload
  # @return Object
  def parse_payload(payload)
    class_name, id = payload.split(',')
    if klass = class_name.safe_constantize
      klass.find(id.to_i) rescue nil
    end
  end

  # Returns the channel to listen to
  # @return String for form `user_ID`
  def channel
    'user_%d' % self.id
  end
end
