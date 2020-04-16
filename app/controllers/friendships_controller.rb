require 'awesome_print'
class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    if friend
      friendship = Friendship.create(user: current_user, friend: friend)
      if friendship.save
        flash[:notice] = "Successfully added #{friend.full_name} as friend"
        redirect_to my_friends_path
      else
        flash[:alert] = "Error while adding #{friend.full_name} to your friends list"
        redirect_to my_friends_path
      end
    else
      flash[:alert] = "Can not add unknown user #{params[:friend]} to your friends list"
      redirect_to my_friends_path
    end
  end

  def destroy
    friend = User.find(params[:id])
    friendship = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
    friendship.destroy
    flash[:notice] = "Successfully removed #{friend.full_name} from your friends list"
    redirect_to my_friends_path
  end
end