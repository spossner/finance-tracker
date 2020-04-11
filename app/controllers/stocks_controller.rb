class StocksController < ApplicationController
  def search
    s = Stock.new_lookup(params[:stock])
    render json: s
  end
end
