# Handles application pages
class PagesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  # Shows main dashboard
  def dashboard
  end

end
