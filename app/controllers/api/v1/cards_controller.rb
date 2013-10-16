# API (v1) [Card] controller class
class Api::V1::CardsController < Api::V1::ApplicationController
  # Shows available cards
  def index
    cards = Card.where(:id => params[:ids])
    current_account.can?(:read, cards)
    render :json => cards
  end

  # Shows available card
  def show
    card = Card.find_by!(:id => params[:id])
    current_account.can?(:read, card)
    render :json => card
  end

  # Handles card creation
  def create
    new_card_params[:user] = current_account
    card = nil

    begin
      klass = ('Card::%s' % new_card_params[:type]).safe_constantize
      raise _('Type is not allowed.') if !klass or klass.equal?(Card)

      current_account.can?(
        :write, Board.find_by(:id => new_card_params[:board_id]))

      card = klass.create!(new_card_params.except(:type))
      render :json => card
    rescue Exception => error
      errors = error ? error.message : card.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Handles card changes
  def update
    klass = ('Card::%s' % card_params[:type].to_s.camelize).safe_constantize

    if klass
      card = klass.find_by!(:id => params[:id])
      current_account.can?(:write, card)
      card_params.merge!({:user => current_account})
      card.update_attributes(card_params.except(:type))
      render :json => card
    else
      render :nothing => true, :status => 400
    end
  end

  # Handles card deletion
  def destroy
    card = Card.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, card, :raise_error => false)

    if card and can_destroy and card.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private
    # Allowed card types
    def card_types
      %w(photo paragraph link map list book interval number
        phrase timestamp video)
    end

    # Strong parameters for creating a new card
    def new_card_params
      card_type = params.slice(*card_types).keys.first
      params[card_type].except!(:user_id, :image_id) if card_type
      params.require(card_type).permit!
    end

    # Strong parameters for updating a card
    def card_params
      card_type = params.slice(*card_types).keys.first
      params[card_type].except!(
        :user_id, :project_id, :board_id, :image_id, :topic_id) if card_type
      params.require(card_type).permit!
    end
end
