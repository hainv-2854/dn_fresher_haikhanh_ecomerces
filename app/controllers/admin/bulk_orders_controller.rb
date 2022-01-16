class Admin::BulkOrdersController < Admin::BaseController
  before_action :load_by_ids, :check_valid_statuses_for_destroy?, only: :destroy

  def destroy
    rejected_count = count_order_rejected
    canceled_count = count_order_canceled

    ActiveRecord::Base.transaction do
      @orders.destroy_all
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t ".destroy_fail"
    redirect_to admin_orders_path
  else
    respond_to do |format|
      format.json do
        render json: {rejected_count: rejected_count,
                      canceled_count: canceled_count}
      end
    end
  end

  private

  def check_valid_statuses_for_destroy?
    return if params[:order_ids].any? &&
              @orders.not_rejected_canceled.empty?

    flash[:danger] = t ".destroy_denied"
    redirect_to admin_orders_path
  end

  def load_by_ids
    @orders = Order.load_by_ids params[:order_ids]
  end

  def count_order_rejected
    @orders.where(status: :rejected).count
  end

  def count_order_canceled
    @orders.where(status: :canceled).count
  end
end
