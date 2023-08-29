class FollowingsController < UsersController
  before_action :find_user, :logged_in_user, only: :index

  def index
    @title = t ".following"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end
end
