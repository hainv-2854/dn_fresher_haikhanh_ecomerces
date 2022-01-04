class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy Product.sort_by_price,
                            items: Settings.length.per_page_12
  end

  def show; end
end
