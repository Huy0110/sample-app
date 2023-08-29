class FollowersController < UsersController
  before_action :find_user, :logged_in_user, only: :index

  def index
    @title = t ".followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end
end
