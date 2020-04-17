require 'awesome_print'

class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:q].present?
      q = "%#{params[:q].strip.downcase}%"
      @users = User.where("(lower(last_name) like :q or lower(first_name) like :q or lower(email) like :q) and id != :current_user_id", q: q, current_user_id: current_user.id)
      if @users.present?
        ap @users
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Could not find any user for <b>#{params[:q]}</b>".html_safe
          format.js { render partial: 'users/result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter something to search for"
        format.js { render partial: 'users/result' }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
