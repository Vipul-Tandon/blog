class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commenter, :body, :like_count

  def like_count
    object.likes.count
  end
end
