class CartsController < ApplicationController
  before_action :load_product, :check_quantity, only: :create

  def index
    @cart_items = load_product_in_cart
    @total_price_cart = total_price_cart @cart_items
  end

  def create
    add_to_cart params[:product_id], params[:quantity]
    flash[:success] = t ".add_success"
    redirect_back fallback_location: root_path
  end

  private

  def check_quantity
    quantity = params[:quantity].to_i
    product_id = params[:product_id]
    quantity += current_cart[product_id] if current_cart[product_id].present?
    return if @product.quantity >= quantity

    flash[:danger] = t ".not_enough"
    redirect_back fallback_location: root_path
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t ".not_found"
    redirect_to static_pages_home_path
  end

  def load_product_in_cart
    cart_items = []
    current_cart.each do |id, quantity|
      product = Product.find_by id: id
      if product
        cart_items << {product: product, quantity_order: quantity,
                       total_price_item: quantity * product[:price]}
      else
        current_cart.delete id
      end
    end
    cart_items
  end

  def total_price_cart cart_items
    cart_items.reduce(0) do |total, item|
      total + item[:total_price_item]
    end
  end
end
