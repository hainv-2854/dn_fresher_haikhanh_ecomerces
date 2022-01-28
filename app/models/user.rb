class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_save :downcase_email

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {user: 0, admin: 1}

  def downcase_email
    email.downcase!
  end
end
