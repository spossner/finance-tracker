class UserStocksController < ApplicationController
  def create
    new_stock = Stock.find_by_ticker(params[:ticker])
    if new_stock.blank?
      new_stock = Stock.new_lookup(params[:ticker])
      new_stock.save
    else
      new_stock.refresh_price
    end

    if new_stock
      @user_stock = UserStock.create(user: current_user, stock: new_stock)
      if @user_stock.save
        flash[:notice] = "Successfully added #{new_stock.name} (#{new_stock.ticker}) to your portfolio"
      else
        flash[:alert] = "Error while adding #{new_stock.name} (#{new_stock.ticker}) to your portfolio"
      end
    else
      flash[:alert] = "Unknown stock #{params[:ticker]}"
    end

    if params[:user] # if user was given, go to users#show page with that user
      redirect_to user_path(params[:user])
    else # and to my portfolio otherwise
      redirect_to my_portfolio_path
    end
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "Successfully removed #{stock.name} (#{stock.ticker}) from your portfolio"
    redirect_to my_portfolio_path
  end
end
