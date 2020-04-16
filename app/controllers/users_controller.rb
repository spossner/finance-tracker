require 'awesome_print'

class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:q].present?
      q = params[:q].downcase
      @users = User.where("lower(last_name) like '%#{q}%' or lower(first_name) like '%#{q}%' or lower(email) like '%#{q}%'")
      respond_to do |format|
        format.js { render partial: 'users/result' }
      end
    end
  end
end
