class SessionsController < ApplicationController
  def create
  	user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    # TODO REDIRECT
    # redirect_to root_path
  end

  def destroy
  	session[:user_id] = nil
  	# TODO REDIRECT
    # redirect_to root_path
  end
end
