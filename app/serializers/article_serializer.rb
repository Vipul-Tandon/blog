class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :username

  has_many :comments, if: -> {@instance_options[:show_comments]}
  
  def username
    object.user.username
  end
end
