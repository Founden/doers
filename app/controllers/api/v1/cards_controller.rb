# API (v1) [Card] controller class
class Api::V1::CardsController < Api::V1::ApplicationController
  # Shows available cards
  def index
    cards = Card.where(
      :id => params[:ids], :project_id => current_account.projects)
    render :json => cards
  end

  # Shows available card
  def show
    card = Card.find_by!(
      :id => params[:id], :project_id => current_account.projects)
    render :json => card
  end

  # Handles card creation
  def create
    new_card_params[:user] = current_account
    card = nil

    begin
      klass = ('Card::%s' % new_card_params[:type]).safe_constantize
      raise _('Type is not allowed.') if !klass or klass.equal?(Card)
      card = klass.create!(new_card_params.except(:type))
      render :json => card
    rescue Exception => error
      errors = error ? error.message : card.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Handles card changes
  def update
    klass = ('Card::%s' % card_params[:type]).safe_constantize || Card
    card = klass.find_by!(
      :id => params[:id], :project_id => current_account.projects)

    card_params = card_params.merge({:user => current_account})
    begin
      card.update_attributes(card_params.except(:type))
      render :json => card
    rescue Exception => error
      errors = error ? [error.message] : card.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Handles card deletion
  def destroy
    card = Card.find_by(
      :id => params[:id], :project_id => current_account.projects)
    if card and card.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new card
    def new_card_params
      params[:card] = params[:card].except(:user_id)
      params.require(:card).permit!
    end

    # Strong parameters for updating a card
    def card_params
      params[:card] = params[:card].except(:user_id, :project_id, :board_id)
      params.require(:card).permit!
    end
end
