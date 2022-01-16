class Admin::OrdersController < Admin::BaseController
  before_action :load_order, except: %i(index)
  before_action :check_valid_status_for_update?, :get_status_name, only: :update
  before_action :check_valid_status_for_destroy?, only: :destroy

  def index
    @pagy, @orders = pagy Order.recent_orders,
                          items: Settings.length.per_page_5
    @count_orders_by_status = count_orders_by_status

    @pagy, @orders = if username.present?
                       pagy @orders.filter_by_name(username)
                     elsif status.present?
                       pagy Order.send(status)
                     end
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

  def destroy
    if @order.destroy
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t ".destroy_fail"
      redirect_to admin_orders_path
    end
  end

  private

  def check_valid_status_for_update?
    return if Order.statuses.values.include?(status_params.to_i) &&
              (@order.status_before_type_cast != status_params.to_i) &&
              (Order.statuses[:pending] != status_params.to_i)

    flash[:danger] = t ".update_status_fail"
    redirect_to admin_orders_path
  end

  def check_valid_status_for_destroy?
    return if @order.rejected? || @order.canceled?

    flash[:danger] = t ".destroy_denied"
    redirect_to admin_orders_path
  end

  def status_params
    params.require :status
  end

  def username
    params.slice(:user_name).values.first
  end

  def status
    params.slice(:status).values.first
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

  def count_orders_by_status
    Order.statuses.keys.map do |key|
      {key => Order.send(key).count}
    end
  end

  def get_status_name
    Order.statuses.keys[params[:status].to_i]
  end

  def update_order status, rejected_reason
    @order.update! status: status
    @order.update! rejected_reason: rejected_reason if rejected_reason.present?
  end
end
