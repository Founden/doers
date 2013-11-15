# Support for [Activity] listening
module Activity::Listener
  # Support for concerns
  extend ActiveSupport::Concern

  # Listens to the channel for notifications and yields if any
  def on_notifications
    self.before_listen if self.respond_to?(:before_listen)

    self.class.connection.execute('LISTEN %s' % channel)
    loop do
      handle_notifications do |incoming|
        yield incoming
      end
    end
  ensure
    self.class.connection.execute('UNLISTEN %s' % channel)

    self.after_listen if self.respond_to?(:after_listen)

    # Make sure we close this connection since its thread will be killed!
    self.class.connection.close()
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
  def channel
    '%s_%d' % [self.class.name.downcase, self.id]
  end
end
