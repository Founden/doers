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
      # TODO: Handle different asset type when more are available
      # TODO: Handle branch_id and assetable authorization
      asset = current_account.images.create!(
        new_asset_params.merge(:attachment => attchmnt))
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

    # Strong parameters for updating a new asset
    def asset_params
      params[:asset].except!(
        :board_id, :type, :project_id, :user_id, :assetable_id, :assetable_type)
      params.require(:asset).permit(:description, :attachment)
    end

    # Strong parameters for creating a new asset
    def new_asset_params
      params.require(:asset).permit(:description, :board_id, :type,
        :project_id, :assetable_id, :assetable_type, :attachment)
    end
end
