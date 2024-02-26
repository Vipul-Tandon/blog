class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :article_count

  has_many :articles, if: -> {@instance_options[:show_articles]}

  attribute :friend_status, if: -> { @instance_options[:show_friend_status] }

  def article_count
    object.articles.count
  end

  def friend_status
    friendship = Friendship.find_by(user: current_user, friend: object)
    friendship.status
  end
end
