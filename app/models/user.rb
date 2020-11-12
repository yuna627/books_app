# frozen_string_literal: true

class User < ApplicationRecord
  has_many :books, dependent: :destroy
  has_one_attached :avatar
  has_many :follower, class_name: 'Relationship',
                      foreign_key: 'follower_id',
                      dependent: :destroy,
                      inverse_of: :follower
  has_many :followed, class_name: 'Relationship',
                      foreign_key: 'followed_id',
                      dependent: :destroy,
                      inverse_of: :followed
  has_many :following_users, through: :follower, source: :followed
  has_many :follower_users, through: :followed, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]
  validates :name, presence: true
  validates :address, length: { maximum: 50 }
  validates :introduction, length: { maximum: 100 }
  validates :zipcode, format: { with: /\A\d{3}-\d{4}\z/ }, allow_blank: true
  validates :uid, uniqueness: { scope: :provider }

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_github_oauth(auth, _signed_in_resource = nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    user ||= User.new(provider: auth.provider,
                      uid: auth.uid,
                      name: auth.info.name,
                      email: auth.info.email,
                      password: Devise.friendly_token[0, 20])
    user.save
    user
  end

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end
end
