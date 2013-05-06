# API (v1) application controller class
class Api::V1::ApplicationController < ActionController::Base
  include ::EasyAuthHelper
  # Checks if an user is authenticated!
  include EasyAuth::Controllers::Authenticated

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :null_session
end
