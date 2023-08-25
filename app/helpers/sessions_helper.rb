module SessionsHelper
  def login user
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
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user&.authenticated? :remember, cookies[:remember_token]
        login user
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
  def logout
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

  # Returns true if the given user is the current user.
  def current_user? user
    user && user == current_user
  end
end
