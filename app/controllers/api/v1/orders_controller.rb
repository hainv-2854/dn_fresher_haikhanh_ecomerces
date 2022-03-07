class Api::V1::OrdersController < ApplicationController
  def index
    @orders = Order.all
  end
end
