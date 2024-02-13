class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commenter, :body
end
