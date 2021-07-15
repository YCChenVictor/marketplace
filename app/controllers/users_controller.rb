class UsersController < ApplicationController

  def follow
    if @user == current_user
      flash.alert = "You cannot follow yourself"
    else
      @user = User.find(params[:id])
      current_user.followees << @user
    end
  end
  
  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
  end

  def show
    @user = User.find_by(id: params[:id])
  end

end
