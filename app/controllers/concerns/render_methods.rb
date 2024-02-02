module RenderMethods
  extend ActiveSupport::Concern

  DEFAULT_OK_RESPONSE_MESSAGE = 'Request processed successfully!'.freeze

  def render_resource(resource:, serializer: nil, status: :ok)
    data = get_prepared_data(resource, serializer: serializer)

    render json: data, status: status
  end

  def render_resources(resources:, serializer: nil, status: :ok)
    data = serializer.present? ? serialize_resources(resources, serializer) : resources

    render json: data, status: status
  end

  def render_resource_or_errors(resource:, serializer: nil, success_status: :ok)
    return render_errors(resource: resource) if resource.errors.any?

    render_resource(resource: resource, serializer: serializer, status: success_status)
  end

  def render_ok_response(message: DEFAULT_OK_RESPONSE_MESSAGE, status: :ok)
    render json: { message: message }, status: status
  end

  def render_errors(resource:)
    render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(model_name = nil)
    model = model_name || controller_name.classify.constantize

    render json: { error: "#{model.model_name.human} not found!" }, status: :not_found
  end

  def render_bad_request(msg: 'Bad request!')
    render json: { error: msg }, status: :bad_request
  end

  private

  def get_prepared_data(resource, serializer: nil)
    return resource if serializer.blank?

    serializer.new(resource).to_json
  end

  def serialize_resources(resources, serializer)
    ActiveModelSerializers::SerializableResource.new(resources, each_serializer: serializer).to_json
  end
end
