class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: [:create, :index]
    
    def index
        @users = User.all
        render json: @users, status: :ok
    end


    def show
        if @user == current_user
            render json: @user, show_articles: true, status: :ok
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end

   
    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    
    def update
        if @user == current_user
            unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages },
                    status: :unprocessable_entity
            end
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
    
    
    def destroy
        if @user == current_user
            @user.destroy
            head :no_content
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
    
    
    private
    def find_user
        @user = User.find_by_username!(params[:_username])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
        params.permit(
        :name, :username, :email, :password, :password_confirmation
        )
    end
end
