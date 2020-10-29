class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :address, length: { maximum: 50 }
  validates :introduction, length: { maximum: 100 }
  validates :zipcode, format: { with: /\A\d{3}[-]\d{4}\z/ }, allow_blank: true

  has_many :books
end
