# API (v1) activities controller class
class Api::V1::ActivitiesController < Api::V1::ApplicationController
  # Lists available activities
  def index
    activities = Activity.where(:id => params[:ids])
    current_account.can?(:read, activities)
    render :json => activities
  end

  # Shows an activity
  def show
    activity = Activity.find_by(:id => params[:id])
    current_account.can?(:read, activity)
    render :json => activity
  end

  # Handles activity deletion
  def destroy
    activity = Activity.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, activity, :raise_error => false)

    if activity and can_destroy and activity.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end
end
