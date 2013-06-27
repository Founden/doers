# API (v1) startups controller class
class Api::V1::StartupsController < Api::V1::ApplicationController
  # Handles startups import
  def create
    startup = params[:startup]
    if !startup[:angel_list_id].blank? and !current_account.importing
      SuckerPunch::Queue.new(:import).
        async.perform(current_account.id, startup[:angel_list_id])
      render :json => {:startup => startup}
    else
      render :json => {:startup => startup}, :status => 403
    end
  end

end
