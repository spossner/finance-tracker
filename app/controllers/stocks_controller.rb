class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No stock found for #{params[:stock]}"
          format.js { render partial: 'users/result' }
        end
      end
    else
      respond_to do |format|

        format.html { render 'users/my_portfolio' }
        format.js do
          flash.now[:alert] = "Please enter a symbol to search"
          render partial: 'users/result'
        end
      end
    end
  end
end
