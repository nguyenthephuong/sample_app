class Micropost < ApplicationRecord
  belongs_to :user

  scope :feeds_following, ->user{where user_id: user.following_ids << user.id}
  scope :orders, ->{order created_at: :desc}

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, t("less_5mb"))
    end
  end
end
