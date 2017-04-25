class UsersController < ApplicationController
  before_action :reject_if_logged_in, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy,
    :correct_user]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: 8
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users_dander"
      redirect_to login_path
    end
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t ".danger"
      redirect_to root_path
    end
  end
end
