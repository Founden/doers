# API (v1) projects controller class
class Api::V1::ProjectsController < Api::V1::ApplicationController

  # Lists available projects
  def index
    render :json => current_account.projects
  end

  # Shows available project
  def show
    render :json => current_account.projects.where(params[:id]).first
  end
end
