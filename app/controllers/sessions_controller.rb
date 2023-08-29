class SessionsController < ApplicationController
  before_action :find_user_base_session, only: :create

  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        handle_auth
      else
        message = t "email_not_activated"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_base_session
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash[:danger] = I18n.t ".error"
    redirect_to action: :new
  end

  def handle_auth
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
    login @user
    redirect_to forwarding_url || @user
  end
end
