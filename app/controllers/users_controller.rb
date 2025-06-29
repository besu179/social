class UsersController < ApplicationController
  include SessionsHelper
  before_action :correct_user, only: [:edit, :update]
  before_action :activated_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:alert] = "User not found"
      redirect_to root_path
    elsif !@user.activated?
      flash[:alert] = "Account not activated. Please check your email for activation link."
      redirect_to root_path
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "Account deleted"
    redirect_to root_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.create_activation_digest
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

  # Before actions
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an activated user.
  def activated_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path unless @user&.activated?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
