class AuthenticationsController < ApplicationController
  skip_before_filter :authenticate_user!
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in(authentication.user)
      redirect_to root_path
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to root_path
    else
      user = User.new
      debugger
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
  protected

# This is necessary since Rails 3.0.4
# See https://github.com/intridea/omniauth/issues/185
# and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end
end
