class ArticlesController < ApplicationController
    before_action :authorize_request, except: [:index, :show]
    before_action :find_article, except: [:create, :index, :show]
    
    def index
        @articles = Article.all
        render json: @articles, status: :ok
    end


    def show
        @article = Article.find_by(id: params[:id])
        render json: @article, show_comments: true, status: :ok
    end


    def create
        @article = current_user.articles.new(article_params)
        if @article.save
            render json: @article, status: :created
        else
            render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def update
        if @article.update(article_params)
            render json: @article, status: :ok
        else
            render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @article.destroy
        head :no_content
    end


    private
        def find_article
            @article = current_user.articles.find_by(id: params[:id])
            if @article
                return @article
            else
                render json: { errors: 'Article not found' }, status: :not_found
            end
        end

        def article_params
            params.require(:article).permit(:title, :body, :status)
        end
end
