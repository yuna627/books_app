# frozen_string_literal: true

class User < ApplicationRecord
  has_many :books, dependent: :destroy
  has_one_attached :avatar
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

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

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
