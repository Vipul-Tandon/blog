class LikesController < ApplicationController
  before_action :authorize_request

  def create
    @likeable = find_likeable
    @like = @likeable.likes.new(user_id: current_user.id)
    if @like.save
      render json: @likeable, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @like = Like.find_by(id: params[:id], user_id: current_user.id)
    if @like
      @like.destroy
      head :no_content
    else
      render json: { error: "Like not found or you don't have permission to delete it" }, status: :not_found
    end
  end


  private
    def find_likeable
      if params[:article_id]
        Article.find(params[:article_id])
      elsif params[:comment_id]
        Comment.find(params[:comment_id])
      end
    end
end
