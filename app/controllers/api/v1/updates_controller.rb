# API (v1) notifications controller class
class Api::V1::UpdatesController < Api::V1::ApplicationController
  # Websockets support
  include Tubesock::Hijack

  # Streams available activities
  def index
    hijack do |tubesock|
      # Listen on its own thread
      socket_thread = Thread.new do
        current_account.on_notifications do |obj|
          tubesock.send_data _render_option_json(obj, {})
        end
      end

      tubesock.onmessage do |msg|
        tubesock.send_data _('Error: 405')
      end

      tubesock.onclose do
        # Stop listening when client leaves
        socket_thread.kill
      end
    end
  end

end
