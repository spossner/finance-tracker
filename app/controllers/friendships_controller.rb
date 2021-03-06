require 'awesome_print'
class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    if friend
      friendship = Friendship.create(user: current_user, friend: friend)
      if friendship.save
        flash[:notice] = "Successfully added #{friend.full_name} as friend"
      else
        flash[:alert] = "Error while adding #{friend.full_name} to your friends list"
      end
    else
      flash[:alert] = "Can not add unknown user #{params[:friend]} to your friends list"
    end
    if params[:user] # if user was given, go to users#show page with that user
      redirect_to user_path(params[:user])
    else # and to my portfolio otherwise
      redirect_to my_portfolio_path
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