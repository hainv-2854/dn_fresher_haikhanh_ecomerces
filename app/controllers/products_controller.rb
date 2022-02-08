class ProductsController < ApplicationController
  before_action :load_paramsq, only: :index

  def index
    @q = Product.ransack params[:q]
    @categories = Category.order_by_name
    @pagy, @products = pagy @q.result.sort_by_price,
                            items: Settings.length.per_page_12
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t ".not_found"
    redirect_to products_path
  end
end
