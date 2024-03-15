class Comment < ApplicationRecord
  include Visible
  
  belongs_to :article
  belongs_to :user
  has_many :likes, as: :likeable
  has_many :images, as: :imageable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1000 }
end
