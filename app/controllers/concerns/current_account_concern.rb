# This one patches `EasyAuth#current_account` method with our logic
module CurrentAccountConcern
  extend ActiveSupport::Concern

  included do
    # Around alias in order to get account `touch`-ed
    alias_method_chain :current_account, :touch
  end

  # Old `current_account` with a call to current_account#touch
  def current_account_with_touch
    user = current_account_without_touch
    return user if user.blank?

    if user.updated_at.to_i > user.login_at.to_i + Doers::Config.logout_after
      user.update_attributes(:login_at => user.updated_at)
    end
    user
  end

end
