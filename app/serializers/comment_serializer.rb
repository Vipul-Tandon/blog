class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commenter, :body, :like_count

  has_many :images

  def like_count
    object.likes.count
  end

  def commenter
    object.user.username
  end
end
