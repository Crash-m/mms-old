class SessionsController < ApplicationController
  #before_filter :authorize, only: []
  
  def new
  end
  
  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
    
      redirect_to login_path#, notice: "Logged in!"
    else
      #flash.alert = "Email or password is invalid!"
      render "new"
    end
  end
  
  def destroy
    cookies.delete(:auth_token)
    session[:user_id] = nil
    redirect_to login_path#, notice: "Logged out!"
  end
end
