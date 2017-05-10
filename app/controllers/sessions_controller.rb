class SessionsController < ApplicationController
  before_action :reject_if_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "message_active"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "session_danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
