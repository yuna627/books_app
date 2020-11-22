# frozen_string_literal: true

class Report < ApplicationRecord
  include Commentable
  validates :title, presence: true

  belongs_to :user
end
