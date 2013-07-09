# API (v1) [Card] controller class
class Api::V1::CardsController < Api::V1::ApplicationController
  # Shows available cards
  def index
    cards = Card.where(
      :id => params[:ids], :project_id => current_account.projects)
    render :json => cards
  end

end
