class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t "microposts.created"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.destroy_success"
    else
      flash[:danger] = t "microposts.destroy_fail"
    end

    if request.referer.nil?
      redirect_to root_path, status: :see_other
    else
      redirect_to request.referer, status: :see_other
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  # checks that the current user actually has a micropost with the given id
  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.micropost_not_found"
    redirect_to root_path, status: :see_other
  end
end
