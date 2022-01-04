class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :parent, class_name: Comment.name, optional: true
  has_many :childrens, class_name: Comment.name, foreign_key: :parent_id,
    dependent: :destroy
end
