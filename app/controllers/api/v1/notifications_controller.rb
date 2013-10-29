# API (v1) notifications controller class
class Api::V1::NotificationsController < Api::V1::ApplicationController
  # Websockets support
  include Tubesock::Hijack

  # Streams available activities
  def index
    hijack do |tubesock|
      # Listen on its own thread
      activities_thread = Thread.new do
        current_account.activities.each do |act|
          tubesock.send_data _render_option_json(act, {})
          sleep 1
        end
      end

      tubesock.onmessage do |msg|
      end

      tubesock.onclose do
        # Stop listening when client leaves
        activities_thread.kill
      end
    end
  end

end
