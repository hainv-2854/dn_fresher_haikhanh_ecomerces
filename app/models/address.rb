class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  scope :address_order, ->{order(is_default: :desc)}

  validates :address_detail, presence: true,
            length: {in: Settings.length.per_page_5..Settings.length.digit_225}
  validates :phone, presence: true,
            length: {in: Settings.length.digit_9..Settings.length.digit_11}
end
