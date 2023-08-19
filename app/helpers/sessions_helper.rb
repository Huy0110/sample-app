module SessionsHelper
  def log_in user
    session[:user_id] = user.id
    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
  end

  def logged_in?
    current_user.present?
  end

  # Returns the current logged-in user (if any).
  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id) if session[:user_id]
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user&.authenticated? :remember, cookies[:remember_token]
        log_in user
        @current_user = user
      end
    end
  end

  # Forgets a persistent session.
  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
