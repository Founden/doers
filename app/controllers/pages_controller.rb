# Handles application pages
class PagesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  skip_before_filter :require_confirmation, :only => [:waiting]

  # Shows main dashboard
  def dashboard
  end

  # Show this page for unconfirmed users
  def waiting
  end

end
