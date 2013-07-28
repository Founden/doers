# API (v1) oEmbed controller class
class Api::V1::EmbedsController < Api::V1::ApplicationController

  # Fetches oEmbed link
  def index
    if Oembedr.known_service?(url) and (embed = Oembedr.fetch(url))
      render :json => [embed], :each_serializer => EmbedSerializer
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for embed request
    def url
      params.require(:url)
    end
end
