class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :article_count

  has_many :articles, if: -> {@instance_options[:show_articles]}

  def article_count
    object.articles.count
  end
end
