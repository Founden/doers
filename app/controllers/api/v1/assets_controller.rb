# API (v1) [Asset] controller class
class Api::V1::AssetsController < Api::V1::ApplicationController
  # Shows available assets
  def index
    assets = Asset.where(
      :id => params[:ids], :project_id => current_account.projects)
    render :json => assets
  end

  # Shows available asset
  def show
    asset = Asset.find_by(
      :id => params[:id], :project_id => current_account.projects)
    render :json => asset
  end

  # Creates an asset
  def create
    # Try a link, maybe it's a remote file
    maybe_link = new_asset_params[:attachment]
    new_asset_params[:attachment] = URI.parse(maybe_link) rescue maybe_link

    # TODO: Handle different asset type when more are available
    asset = current_account.images.build(new_asset_params)
    if asset and asset.save
      render :json => asset
    else
      render :json => { :errors => asset.errors.messages }, :status => 400
    end
  end

  # Destroys the asset
  def destroy
    asset = Asset.find_by(
      :id => params[:id], :project_id => current_account.projects)
    if asset and asset.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new asset
    def new_asset_params
      params.require(:asset).permit(:description, :board_id, :type,
        :project_id, :assetable_id, :assetable_type, :attachment)
    end
end
