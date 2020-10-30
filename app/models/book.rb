class Book < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :title, presence: true

  belongs_to :user
end
