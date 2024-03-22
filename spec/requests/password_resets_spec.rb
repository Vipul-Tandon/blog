require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  
  describe "POST /password_resets" do
    context 'when user exists' do
      it 'sends OTP successfully' do
        post '/password_resets', params: { email: user.email }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message', 'otp')
      end
    end
    
    context 'when user does not exist' do
      it 'returns not found' do
        post '/password_resets', params: { email: 'nonexistent@example.com' }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end


  describe 'PUT /password_resets' do
    
    context 'with valid OTP' do
      it 'updates password successfully' do
        put '/password_resets', params: { email: user.email, otp: user.otp, password: 'Swajhb@12jk', password_confirmation: 'Swajhb@12jk' }
        
        byebug
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
      end
    end
    
    context 'with invalid OTP' do
      it 'returns unprocessable entity' do
        put '/password_resets', params: { email: user.email, otp: 'invalid_otp', password: 'new_password', password_confirmation: 'new_password' }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end
end
