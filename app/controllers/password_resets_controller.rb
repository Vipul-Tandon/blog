class PasswordResetsController < ApplicationController
  before_action :set_user 
  after_action :reset_otp, only: :update

  # Forgot password
  def create
    otp = generate_otp
    # Rails.cache.write("password_reset_#{@user.id}", otp, expires_in: 4.minutes)
    @user.otp = otp
    if @user.save
      UserMailer.password_reset(@user, otp).deliver_now
      render json: { message: 'OTP sent successfully', otp: otp }, status: :ok
    else
      render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
    end
  end

  
  # Reset password
  def update
    otp = @user.otp
    if otp != nil && params[:otp] == otp
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        # Rails.cache.delete("password_reset_#{@user.id}")
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages },
                    status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid OTP or OTP expired' }, status: :unprocessable_entity
    end
  end


  private
    def set_user
      @user = User.find_by(email: params[:email])
      if !@user
        render json: { errors: 'User not found' }, status: :not_found
      end
    end

    def generate_otp
      SecureRandom.random_number(100000..999999)
    end

    def reset_otp
      @user.otp = nil
      @user.save
    end
end
