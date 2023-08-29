class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.activate"
      redirect_to login_url
    else
      flash.now[:danger] = t("users.new.error")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("users.edit.success")
      redirect_to @user
    else
      flash[:danger] = t("users.edit.error")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("users.edit.delete")
      redirect_to users_url, status: :see_other
    else
      flash[:danger] = t("users.edit.error")
      redirect_to users_url, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters
  # Confirms a logged-in user
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.required_login")
    redirect_to login_url, status: :see_other
  end

  def find_user
    @user = User.find_by id: params[:id]
    redirect_to root_path, flash: {warning: t(".index.error")} if @user.nil?
  end

  # Confirms the correct user.
  def correct_user
    redirect_to root_path, status: :see_other unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path, status: :see_other unless current_user.admin?
  end
end
