class Api::V1::CartsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_product, :check_quantity, only: %i(create update)
  before_action :check_product_cart, only: %i(update destroy)

  def index
    @cart_items = load_product_in_cart
    @total_price_cart = total_price_cart @cart_items
  end

  def create
    add_to_cart params[:product_id], params[:quantity]
    render_json :message, t(".add_success"), :ok
  end

  def update
    current_cart[params[:product_id].to_s] = params[:quantity].to_i
    render_json :message, t(".update_success"), :ok
  end

  def destroy
    current_cart.delete params[:product_id].to_s
    render_json :message, t(".delete_success"), :ok
  end

  private

  def check_quantity
    quantity = params[:quantity].to_i
    quantity += current_cart[params[:product_id]] if check_product_id?
    quantity = params[:quantity].to_i if check_update?
    return if @product.quantity >= quantity

    render_json :message, t(".not_enough"), 413
  end

  def check_product_id?
    current_cart[params[:product_id]].present?
  end

  def check_update?
    params[:is_update].present?
  end

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    render_json :message, t(".not_found"), :not_found
  end

  def check_product_cart
    return if current_cart[params[:product_id].to_s].present?

    render_json :message, t(".not_found"), :not_found
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
end
