module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include RenderMethods

      before_action :ensure_params_exist, only: :create
      skip_before_action :verify_authenticity_token, only: :create

      def create
        user = User.new(user_params)

        if user.save
          render_resource(resource: user, serializer: nil, status: :created)
        else
          render_resource(resource: { message: 'Sing Up Failed' }, serializer: nil, status: :unprocessable_entity)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def ensure_params_exist
        return if params[:user].present?

        render_resource(resource: { message: 'Missing Params' }, serializer: nil, status: :bad_request)
      end
    end
  end
end
