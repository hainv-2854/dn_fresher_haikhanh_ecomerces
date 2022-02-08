class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy
  delegate :name, to: :user, prefix: true
  delegate :phone, :address_detail, to: :address, prefix: true

  acts_as_paranoid

  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3, canceled: 4}

  scope :recent_orders, ->{order(status: :asc, created_at: :desc)}
  scope :filter_by_name, ->(n){joins(:user).where("name LIKE ?", "%#{n}%")}
  scope :load_by_ids, ->(ids){where id: ids}
  scope :not_rejected_canceled, ->{where.not(status: [:rejected, :canceled])}
  scope :not_deleted, ->{where(deleted_at: nil)}

  class << self
    def count_orders_by_status
      statuses.keys.map do |key|
        {key => send(key).count}
      end
    end

    def count_orders_deleted_by_status
      statuses.keys.map do |key|
        {key => send(key).only_deleted.count}
      end
    end
  end

  def calculate_total
    order_details.reduce(0) do |total, item|
      total + item.quantity * item.product.price
    end
  end

  def calculate_total_deleted
    order_details.with_deleted.reduce(0) do |total, item|
      total + item.quantity * item.product.price
    end
  end

  def calculate_time_remain_to_destroy
    time_in_trash = Settings.order.time_in_trash
    time_remain = (deleted_at.to_date + time_in_trash - Date.current).to_i
    time_remain.negative? ? 0 : time_remain
  end

  def permit_delete?
    rejected? || canceled?
  end

  private

  def restore_product_quantity_when_rejected
    order_details.each do |order_detail|
      product = order_detail.product
      product.update!(quantity: product.quantity + order_detail.quantity)
    end
  end

  def restore_product_quantity_when_accept
    # send email to user
  end

  def restore_product_quantity_when_resolved
    update(delivered_at: Time.zone.now)
  end
end
