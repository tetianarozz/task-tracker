module Api
  module V1
    class SessionsController < Devise::SessionsController
      include RenderMethods

      before_action :sign_in_params, only: :create
      before_action :find_user, only: :create
      skip_before_action :verify_authenticity_token, only: :create

      def create
        if @user.valid_password?(sign_in_params[:password])
          sign_in 'user', @user

          render_resource(resource: @user, serializer: nil)
        else
          response = { messages: 'Signed In Failed - Unauthorized' }

          render_resource(resource: response, serializer: nil, status: :unauthorized)
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def find_user
        @user = User.find_for_database_authentication(email: sign_in_params[:email])
        return @user if @user

        response = { messages: 'Invalid Email or Password' }

        render_resource(resource: response, serializer: nil, status: :unauthorized)
      end
    end
  end
end
