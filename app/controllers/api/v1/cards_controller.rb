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
    card = Card.find_by(
      :id => params[:id], :project_id => current_account.projects)
    render :json => card
  end

  # Handles card creation
  def create
    card = current_account.cards.build(new_card_params)
    klass = ('Cards::%s' % params[:card][:type]).constantize rescue false
    card.type = klass
    if klass and card.save
      render :json => card
    else
      render :json => { :errors => card.errors.messages }, :status => 400
    end
  end

  # Handles card changes
  def update
    card = Card.find_by(
      :id => params[:id], :project_id => current_account.projects)
    if card.update_attributes(card_params)
      render :json => card
    else
      render :json => { :errors => card.errors.messages }, :status => 400
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
      params.require(:card).permit(:title, :project_id, :board_id, :type)
    end

    # Strong parameters for updating a card
    def card_params
      params[:card] = params[:card].
        except(:user_id, :project_id, :board_id, :type)
      params.require(:card).permit!
    end
end
