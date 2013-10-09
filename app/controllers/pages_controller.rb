# Handles application pages
class PagesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  skip_before_filter :require_confirmation, :only => [:waiting, :promo_code]

  # Shows main dashboard
  def dashboard
  end

  # Show this page for unconfirmed users
  def waiting
    if params[:user] and current_account.update_attributes(user_params)
      flash[:success] = _('Your application was updated. Thank you.')
    end
  end

  # Show the page for claiming promo codes
  def promo_code
    code = params[:user] ? params[:user][:promo_code] : nil
    if code and Doers::Config.promo_codes.include?(code)
      current_account.update_attributes(:promo_code => code, :confirmed => true)
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
    params.require(:user).permit(:interest, :newsletter_allowed)
  end

end
