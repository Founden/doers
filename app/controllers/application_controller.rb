# Main application controller class
class ApplicationController < ActionController::Base
  include EasyAuthHelper
  include AvatarHelper
  include ApplicationHelper
  include CurrentAccountConcern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  # Set up a filter to handle users without confirmation
  before_filter :require_confirmation

  private

  # Handle users without confirmation
  def require_confirmation
    if account_signed_in? and !current_account.confirmed?
      redirect_to waiting_pages_path
    end
  end
end
