# API (v1) startups controller class
class Api::V1::StartupsController < Api::V1::ApplicationController
  # Handles startups import
  def create
    startup = current_account.projects.find_by(
      :external_id => startup_params[:external_id].to_s)

    if !startup
      current_account.update_attributes(:importing => true)
      job = Delayed::Job.enqueue(ImportJob.new(
        current_account, startup_params[:external_id]))

      render :json => {:job => job.id}, :status => 200
    else
      error = _('Failed to import a duplicate.')
      render :json => {:errors => [error], :startup => startup}, :status => 400
    end
  end

  private
    # Strong parameters for creating a startup import
    def startup_params
      params.require(:startup).permit(:external_id)
    end
end
