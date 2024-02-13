class CommentsController < ApplicationController
    before_action :authorize_request  

    def index
      @article = current_user.articles.find_by(id: params[:article_id])
      @comments = @article.comments.all
      render json: @comments, status: :ok
    end
    
    def create
      puts current_user.attributes
      @article = current_user.articles.find_by(id: params[:article_id])
      @comment = @article.comments.create(comment_params)
      @comment.commenter = current_user.username

      if @comment.save
        render json: @comment, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
        @comment = Comment.find_by(id: params[:id])
        @comment.destroy
        head :no_content
    end
  
    private
      def comment_params
        params.require(:comment).permit(:body, :status)
      end
end
  