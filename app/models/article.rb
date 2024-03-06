class Article < ApplicationRecord
    include Visible
    
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable

    has_many :shares, dependent: :destroy
    has_many :shared_by_users, through: :shares, source: :user

    paginates_per 5
    
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
end
