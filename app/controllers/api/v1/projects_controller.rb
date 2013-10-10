# API (v1) projects controller class
class Api::V1::ProjectsController < Api::V1::ApplicationController

  # Lists available projects
  def index
    projects = Project.where(:id => params[:ids])
    current_account.can?(:read, projects)
    render :json => projects
  end

  # Shows available project
  def show
    project = Project.find_by!(:id => params[:id])
    current_account.can?(:read, project)
    render :json => project
  end

  # Handles project creation
  def create
    project = current_account.created_projects.build(project_params)
    if project.save
      render :json => project
    else
      render :json => { :errors => project.errors.messages }
    end
  end

  # Handles project changes
  def update
    project = Project.find_by!(:id => params[:id])
    current_account.can?(:write, project)
    project.update_attributes(project_params)
    render :json => project
  end

  # Handles project deletion
  def destroy
    project = Project.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, project, :raise_error => false)
    if can_destroy and project and project.destroy
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
