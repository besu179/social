class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      flash.now[:danger] = "Micropost could not be created: #{@micropost.errors.full_messages.join(', ')}"
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost
      @micropost.destroy
      flash[:success] = "Micropost deleted"
      redirect_to request.referer || root_url
    else
      flash[:danger] = "Micropost not found"
      redirect_to root_url
    end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Micropost not found"
    redirect_to root_url
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = e.message
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
