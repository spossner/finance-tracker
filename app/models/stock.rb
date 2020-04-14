class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def Stock.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
        endpoint: 'https://sandbox.iexapis.com/v1')
    begin
      new ticker: ticker_symbol.upcase, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol)
    rescue => ex
      return nil
    end
  end

  def refresh_price
    client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
        endpoint: 'https://sandbox.iexapis.com/v1')
    update(last_price: client.price(ticker))
  end
end
