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
        redirect_to my_portfolio_path
      else
        flash[:alert] = "Error while adding #{new_stock.name} (#{new_stock.ticker}) to your portfolio"
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Unknown stock #{params[:ticker]}"
      redirect_to my_portfolio_path
    end
  end
end
