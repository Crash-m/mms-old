class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  #before_filter :authorize, only: [:index, :edit]
  before_filter :authorize_admin, only: []
  before_filter :authorize_poweruser, only: [:new, :show, :index, :edit, :update, :destroy]
  
  def index
    @users = User.order(sort_column + " " + sort_direction).page(params[:page]).per(25)
    @user = User.order(sort_column + " " + sort_direction).page(params[:page]).per(25)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    
    if @user.save
      if !current_user
        cookies[:auth_token] = @user.auth_token
        redirect_to materials_path, :notice => "Thank you for signing up!"
      else
        redirect_to materials_path, :notice => "New user was created."
      end
    else
      render "new"
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    current_user
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
    
  end
  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    redirect_to users_path, :notice => "Successfully deleted user. #{undo_link}"
  end
  
  private
      
    def undo_link
      view_context.link_to("undo", revert_version_path(@user.versions.where(nil).last), :method => :post)
    end
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :auth_token, :user_name, :admin, :id, :poweruser)
    end
    
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
end
