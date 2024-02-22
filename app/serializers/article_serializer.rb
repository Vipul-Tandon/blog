class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :username, :like_count

  has_many :comments, if: -> {@instance_options[:show_comments]}
  
  def username
    object.user.username
  end

  def like_count
    object.likes.count
  end
end
