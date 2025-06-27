class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def show
    User.find(params[:id])
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "wellcome to the sample app"
      redirect_to @user
    else
      render "new", status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
