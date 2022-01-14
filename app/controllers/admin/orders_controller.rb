class Admin::OrdersController < Admin::BaseController
  before_action :load_order, only: %i(update show check_valid_status?)
  before_action :check_valid_status?, :get_status_name, only: :update

  def index
    @pagy, @orders = pagy Order.recent_orders,
                          items: Settings.length.per_page_5
  end

  def update
    ActiveRecord::Base.transaction do
      update_order status_params.to_i, rejected_reason_message
      if Order.private_instance_methods.include?(
        "restore_product_quantity_when_#{get_status_name}".to_sym
      )
        @order.send "restore_product_quantity_when_#{get_status_name}"
      end
      flash[:success] = t ".update_status_success"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t ".update_status_fail"
  ensure
    redirect_to admin_orders_path
  end

  def show; end

  private

  def check_valid_status?
    return if Order.statuses.values.include?(status_params.to_i) &&
              (@order.status_before_type_cast != status_params.to_i) &&
              (Order.statuses[:pending] != status_params.to_i)

    flash[:danger] = t ".update_status_fail"
    redirect_to admin_orders_path
  end

  def status_params
    params.require(:status)
  end

  def rejected_reason_message
    params[:rejected_reason]
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t ".not_found"
    redirect_to admin_orders_path
  end

  def get_status_name
    Order.statuses.keys[params[:status].to_i]
  end

  def update_order status, rejected_reason
    @order.update! status: status
    @order.update! rejected_reason: rejected_reason if rejected_reason.present?
  end
end
