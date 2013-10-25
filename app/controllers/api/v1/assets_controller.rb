# API (v1) [Asset] controller class
class Api::V1::AssetsController < Api::V1::ApplicationController
  # Shows available assets
  def index
    assets = Asset.where(:id => params[:ids])
    current_account.can?(:read, assets)
    render :json => assets
  end

  # Shows available asset
  def show
    asset = Asset.find_by!(:id => params[:id])
    current_account.can?(:read, asset)
    render :json => asset
  end

  # Updates available asset
  def update
    # Try a link, maybe it's a remote file
    attchmnt = new_asset_params[:attachment]
    attchmnt = URI.parse(attchmnt) if attchmnt.to_s.match(Asset::URI_REGEXP)

    asset = Asset.find_by!(:id => params[:id])
    current_account.can?(:write, asset)

    begin
      asset.update_attributes(asset_params.merge(:attachment => attchmnt))
      render :json => asset
    rescue Exception => error
      errors = !!error ? [error.message] : asset.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Creates an asset
  def create
    # Try a link, maybe it's a remote file
    attchmnt = new_asset_params[:attachment]
    attchmnt = URI.parse(attchmnt) if attchmnt.to_s.match(Asset::URI_REGEXP)

    begin
      klass = ('Asset::%s' % new_asset_params[:type]).safe_constantize
      raise _('Type is not allowed.') if !klass or klass.equal?(Asset)

      asset = klass.new(
        new_asset_params.except(:type).merge(:attachment => attchmnt))
      target = asset.assetable || asset.board || asset.project
      current_account.can?(:write, target)
      asset.user = current_account
      asset.save!

      render :json => asset
    rescue Exception => error
      errors = !!error ? [error.message] : asset.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Destroys the asset
  def destroy
    asset = Asset.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, asset, :raise_error => false)

    if asset and can_destroy and asset.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private
    # Allowed asset types
    def asset_types
      %w(avatar banner cover image logo asset)
    end

    # Strong parameters for updating a new asset
    def asset_params
      asset_type = params.slice(*asset_types).keys.first
      params[asset_type].except!(:board_id, :type, :project_id, :user_id,
        :assetable_id, :assetable_type) if asset_type
      params.require(asset_type).permit(:description, :attachment)
    end

    # Strong parameters for creating a new asset
    def new_asset_params
      asset_type = params.slice(*asset_types).keys.first
      params.require(asset_type).permit(:description, :board_id, :type,
        :project_id, :assetable_id, :assetable_type, :attachment)
    end
end
