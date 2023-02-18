class Recipe < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments , dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
