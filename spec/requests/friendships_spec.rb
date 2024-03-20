require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  let(:friend) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:user) { create(:user) }


  describe "POST /friendships/:friend_id" do
    context "when the friend request is sent successfully" do

      it "sends a friend request" do
        post "/friendships/#{friend.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Friend request sent to #{friend.username}")
      end
    end
    
    context "when the friend request fails due to user blocking friend" do
      
      it "returns unprocessable entity status" do
        create(:blocked_user, user: user, blocked_user: friend)
        post "/friendships/#{friend.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("User not found ~X<o>X~")
      end
    end
    
    context "when the friend request fails due to cooldown period" do
      
      it "returns unprocessable entity status" do
        create(:friendship, user: user, friend: friend, status: "declined", cooldown: 30.days.from_now)
        post "/friendships/#{friend.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Cannot send friend request yet. Cooldown period active")
      end
    end
  end
  
  
  
  describe "GET /friendships" do
    context "when user has friends" do
      
      it "returns a list of friends" do
        create(:friendship, user: user, friend: friend, status: "accepted")
        get "/friendships", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
    
    context "when user has no friends" do
      
      it "returns an empty list" do
        get "/friendships", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end
  
  
  
  describe "PATCH /friendships/:friend_id" do
    context "when the friend request is accepted successfully" do
      
      it "accepts a friend request" do
        create(:friendship, user: friend, friend: user, status: "pending")
        patch "/friendships/#{friend.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Friend request from #{friend.username} accepted")
      end
    end
  end
  
  
  
  describe "PUT /friendships/:friend_id" do
    context "when the friend request is rejected successfully" do
      before do
        create(:friendship, user: friend, friend: user, status: "pending")
      end
      
      it "rejects a friend request" do
        put "/friendships/#{friend.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Friend request from #{friend.username} declined")
      end
    end

    context "with invalid params" do
      it "should return error" do
        put "/friendships/hadvjwjhdvd212", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  
  

  describe "GET /friendships/pending_requests" do
    context "when user has pending friend requests" do
      before do
        create(:friendship, user: friend, friend: user, status: "pending")
      end

      it "returns pending friend requests" do
        get "/friendships/pending_requests", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context "when user has no pending friend requests" do
      it "returns an empty list" do
        get "/friendships/pending_requests", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end
end
