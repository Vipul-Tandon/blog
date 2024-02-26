class FriendshipsController < ApplicationController
    before_action :authorize_request
    before_action :set_friend, except: :index

    # All friends
    def index
        @friends = current_user.friends
        render json: @friends, show_friend_status: true, status: :ok
    end
    
    # Send friend request
    def create
        @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: "pending")
        if @friendship.save
            render json: { message: "Friend request sent to #{@friend.username}" }, status: :created
        else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # Accept friend request
    def update
        @friendship = current_user.inverse_friendships.find_by(user: @friend)
        # render json: @friendship
        if @friendship.update(status: "accepted")
            render json: { message: "Friend request from #{@friend.username} accepted" }, status: :ok
        else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # Reject friend request
    def destroy
        @friendship = current_user.inverse_friendships.find_by(user: @friend)
        @friendship.destroy
        head :no_content
    end

    
    def pending_requests
        pendin_requests = current_user.inverse_friendships.where(status: "pending")
        render json: pendin_requests, status: :ok
    end


    private
        def set_friend
            @friend = User.find_by(id: params[:friend_id])
        end
end