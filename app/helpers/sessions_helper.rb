module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def logged_in?
    current_user.present?
  end

  # Returns the current logged-in user (if any).
  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end