class Admin::OrdersController < Admin::BaseController
  def index
    @pagy, @orders = pagy Order.recent_orders,
                          items: Settings.length.per_page_5
  end
end
