class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "message_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "message_reset_error"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("password_blank")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
        redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "check_expired"
      redirect_to new_password_reset_url
    end
  end
end
