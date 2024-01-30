module Api
  module V1
    class BaseController < ApplicationController
      include RenderMethods

      def serializer
        "#{controller_name.classify}Serializer".constantize
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        model = e.model.constantize

        render_not_found(model)
      end
    end
  end
end
