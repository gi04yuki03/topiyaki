class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attachment :profile_image
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :name,    presence: true, length: { maximum: 10 }
  validates :profile, presence: true, length: { maximum: 100 }, on: :update
  
  has_many :recipes
  has_many :favorites, dependent: :destroy
  has_many :comments , dependent: :destroy

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password = user.password_confirmation
      user.name = "ゲスト"
      user.profile = "hello"
    end
  end
end
