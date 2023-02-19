class Recipe < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments , dependent: :destroy
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validate :require_any_ingredients

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def require_any_ingredients
    errors.add(:base, "材料は1つ以上登録してください。") if self.ingredients.empty?
  end
end
