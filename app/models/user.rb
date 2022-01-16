class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {user: 0, admin: 1}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end
end
