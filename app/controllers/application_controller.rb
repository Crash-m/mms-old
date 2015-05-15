class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
private
  def current_user
 #   @current_user ||= User.find(cookies[:auth_token]) if cookies[:auth_token] 
  @current_user ||= User.where("auth_token =?", cookies[:auth_token]).first if cookies[:auth_token]
  end
  helper_method :current_user
  
  def authorize
    if current_user.nil?
    redirect_to login_url, alert: "Not Authorized"
    else
      if !current_user.admin || !current_user.poweruser
      else
        redirect_to login_url, alert: "Not Authorized"
      end
    end
    
   
  end
  
  def authorize_admin
    if !current_user.nil?
     #if (!current_user[:admin])
     if (!current_user[:admin])
        redirect_to login_url, alert: "Not Authorized"
       end
     end
    end

  
  def authorize_poweruser
    # checks to see if the session has current user logged in
    if !current_user.nil?
      # if a user is present checks to see if they are an admin
      if (!current_user[:admin])
        # if they aren't an admin checks to see if they are a poweruser
        if (!current_user[:poweruser])
          # if they aren't a poweruser, redirects them back to the login
          redirect_to login_url, alert: "Not Authorized"
        end
      end
    end
  end
  
end
