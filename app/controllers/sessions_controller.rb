class SessionsController < ApplicationController
  skip_before_action :authorize, only: %i[new create]
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate?(params[:password_digest])
      session[:user_id] = user.id
      redirect_to tasks_path
    else
      flash[:alert] = "Oops! Credentials not correct"
      redirect_to new_sessions_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to new_sessions_path
  end

  def show
    @current_user ||= User.find(session[:user])
  end

  def edit
    @current_user ||= User.find(session[:user])
  end

  def update
    if @current_user.update_attributes!(params.require(:current_user).permit(:name, :email, :role,
    :phone, :address))
      redirect_to sessions_path
    else
      render 'edit'
    end
  end  


end
