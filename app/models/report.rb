class Report < ApplicationRecord
  include Commentable
  validates :title, presence: true

  belongs_to :user
end
