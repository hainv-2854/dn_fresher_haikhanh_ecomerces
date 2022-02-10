class Admin::ProductsController < Admin::AdminController
  before_action :find_product, except: %i(index new)
  before_action :load_paramsq, only: :index

  def index
    @q = Product.ransack params[:q]
    @categories = Category.order_by_name
    @pagy, @products = pagy @q.result.sort_by_price,
                            items: Settings.length.per_page_5
  end

  def new; end

  def show; end

  private
  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t ".not_found"
    redirect_to admin_products_path
  end
end
