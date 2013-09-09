# API (v1) teams controller class
class Api::V1::TeamsController < Api::V1::ApplicationController
  # Shows teams
  def index
    teams = Team.find_by(:slug => params[:slug])
    render :json => teams
  end

  # Shows a certain team
  def show
    team = Team.find_by(:id => params[:id])
    render :json => team
  end
end
