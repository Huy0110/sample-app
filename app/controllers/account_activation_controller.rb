class AccountActivationController < ApplicationController
  before_action :find_user, only: %i(edit)

  def edit
    if !user.activated? && user.authenticated?(:activation, params[:id])
      handle_edit_success
    else
      flash[:danger] = t "account_activation.invalid"
      redirect_to root_url
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    redirect_to root_path,
                flash: {warning: t("users.index.error")}
  end

  def handle_edit_success
    user.activate
    login user
    flash[:success] = t "account_activation.success"
    redirect_to user
  end
end
