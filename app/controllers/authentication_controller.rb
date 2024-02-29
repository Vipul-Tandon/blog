class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        @user = User.find_by_email(params[:email])

        if @user&.authenticate(params[:password])
            if @user.account_verification.email_confirmed
                token = JsonWebToken.encode(user_id: @user.id)
                time = Time.now + 24.hours.to_i
                render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                                username: @user.username }, status: :ok
            else
                render json: { error: 'Please verify your account to continue' }, status: :unauthorized
            end
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end

    private
    def login_params
        params.permit(:email, :password)
    end
end
