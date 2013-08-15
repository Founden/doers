# API (v1) projects controller class
class Api::V1::ProjectsController < Api::V1::ApplicationController

  # Lists available projects
  def index
    projects = current_account.projects.find(params[:ids])
    render :json => projects
  end

  # Shows available project
  def show
    project = current_account.projects.find(params[:id])
    render :json => project
  end

  # Handles project creation
  def create
    project = current_account.projects.build(project_params)
    if project.save
      render :json => project
    else
      render :json => { :errors => project.errors.messages }
    end
  end

  # Handles project changes
  def update
    project = current_account.projects.find(params[:id])
    project.update_attributes(project_params)
    render :json => project
  end

  # Handles project deletion
  def destroy
    project = current_account.projects.find_by(:id => params[:id])
    if project and project.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for project object
    def project_params
      params.require(:project).permit(:title, :description, :website)
    end
end
