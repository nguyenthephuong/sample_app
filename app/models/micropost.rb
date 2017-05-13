class Micropost < ApplicationRecord
  belongs_to :user

  scope :orders, ->{order created_at: :desc}
  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
