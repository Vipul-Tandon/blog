require 'rails_helper'

RSpec.describe "Shares", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:share) { create(:share, user: user) }
  let!(:shares) { create_list(:share, 3, user: user) }
  let(:friend) { create(:user) }
  let(:article) { create(:article, user: friend, status: 'public') }


  describe 'GET /shares' do
    it 'returns a list of shares' do
      get '/shares', headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      expect(JSON.parse(response.body).size).to eq(shares.size)
    end
  end


  describe 'POST /shares/:article_id' do    
    context 'when sharing with a friend' do
      it 'creates a share successfully' do
        create(:friendship, user: user, friend: friend, status: "accepted")
        post "/shares/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('message', 'share')
      end
    end
    
    context 'when sharing with a non-friend' do
      it 'returns unauthorized' do
        post "/shares/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
    
    context 'when sharing a private article' do
      it 'returns unauthorized' do
        article.update(status: 'private')      
        post "/shares/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end


  describe 'DELETE /shares/:id' do
    context "when the share exists" do
      it 'deletes the share successfully' do
        delete "/shares/#{share.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:no_content)
      end
    end
      
    context "when the share does not exists" do
      it "give an error" do
        delete "/shares/sharghgveid", headers: { 'Authorization': "Bearer #{token}" }
      
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
