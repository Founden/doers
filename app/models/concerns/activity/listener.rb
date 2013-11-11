# Support for [Activity] listening
module Activity::Listener
  # Support for concerns
  extend ActiveSupport::Concern

  # Listens to the channel for notifications and yields if any
  def on_notifications
    self.class.connection.execute('LISTEN %s' % channel)
    loop do
      handle_notifications do |incoming|
        yield incoming
      end
    end
  ensure
    self.class.connection.execute('UNLISTEN %s' % channel)
  end

  private

  # Listens and handles any incoming notifications
  def handle_notifications
    self.class.connection.raw_connection.wait_for_notify do |ev, pid, payload|
      if parsed_payload = parse_payload(payload)
        yield parsed_payload
      end
    end
  end

  # Handles payload
  # @param String payload
  # @return Object
  def parse_payload(payload)
    payload_class, payload_id = payload.split(',')
    if payload_class and klass = payload_class.safe_constantize
      klass.find(payload_id.to_i) rescue nil
    end
  end

  # Returns the channel to listen to
  # @return String for form `user_ID`
  def channel
    'user_%d' % self.id
  end
end
