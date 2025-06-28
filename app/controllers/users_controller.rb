class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  def new
    @user = User.new
  end
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:alert] = "User not found"
      redirect_to root_path
    end
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

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = "wellcome to the social app"
      redirect_to @user
    else
      render "new", status: :unprocessable_entity
    end
  end
  private

  # Before actions
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
