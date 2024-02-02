module Api
  module V1
    class BaseController < ApplicationController
      include RenderMethods

      acts_as_token_authentication_handler_for User

      before_action :authenticate_user!
      skip_before_action :verify_authenticity_token

      def serializer
        "#{controller_name.classify}Serializer".constantize
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        model = e.model.constantize

        render_not_found(model)
      end

      private

      def authenticate_user!
        return if user_signed_in? || authenticate_with_token

        render_resource(resource: { error: 'Unauthorized' }, serializer: nil, status: :unauthorized)
      end

      def authenticate_with_token
        authenticate_with_http_token { |token, _options| User.find_by(authentication_token: token) }
      end
    end
  end
end
