class AccountActivationController < ApplicationController
  before_action :find_user, only: %i(edit)

  def edit
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = t "account_activation.success"
      redirect_to user
    else
      flash[:danger] = t "account_activation.invalid"
      redirect_to root_url
    end
  end

  private
  def find_user
    @user = User.find_by email: params[:email]
    redirect_to root_path, flash: {warning: t("users.index.error")} if @user.nil?
  end
end
