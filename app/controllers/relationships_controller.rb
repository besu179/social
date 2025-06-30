class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by(id: params[:followed_id])
    if @user && @user != current_user
      if current_user.follow(@user)
        respond_to do |format|
          format.html { redirect_to @user }
          format.turbo_stream
        end
      else
        flash[:danger] = "Could not follow user"
        redirect_to @user
      end
    else
      flash[:danger] = "User not found or cannot follow yourself"
      redirect_to root_url
    end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "User not found"
    redirect_to root_url
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = e.message
    redirect_to root_url
  end

  def destroy
    @relationship = Relationship.find_by(id: params[:id])
    if @relationship && @relationship.follower_id == current_user.id
      current_user.unfollow(@relationship.followed)
      respond_to do |format|
        format.html { redirect_to @relationship.followed }
        format.turbo_stream
      end
    else
      flash[:danger] = "Relationship not found or unauthorized"
      redirect_to root_url
    end
  end
end
