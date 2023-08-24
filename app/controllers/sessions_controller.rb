class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page
      reset_session
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      login user
      redirect_to user
    else
      # Create an error message
      flash.now[:danger] = t("invalid_email_password_combination")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url, status: :see_other
  end
end
