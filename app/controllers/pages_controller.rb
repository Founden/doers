# Handles application pages
class PagesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  skip_before_filter :require_confirmation, :only => [:waiting]

  # Shows main dashboard
  def dashboard
  end

  # Export download page
  def export
  end

  # Sends the export data to download
  def download
    Delayed::Job.enqueue(ExportJob.new(current_account))
    flash[:success] = _('Give us some time then check your email.')
    redirect_to export_pages_path
  end

  # Show the page for claiming promo codes
  def waiting
    code = params[:user] ? params[:user][:promo_code] : nil
    if code and Doers::Config.promo_codes.include?(code)
      current_account.update_attributes(user_params.merge(:confirmed => true))
      notice = _("Code worked! Please don't forget to leave your feedback.")
      redirect_to root_path, :notice => notice
    else
      flash[:alert] =
        _("Sorry, but we couldn't validate that promo code.") if code
    end
  end

  private

  # Allowed params for [User] objects
  def user_params
    params.require(:user).permit(:interest, :newsletter_allowed, :promo_code)
  end

end
