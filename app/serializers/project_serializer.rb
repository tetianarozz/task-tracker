class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  attribute :tasks, if: -> { instance_options[:with_tasks].present? }

  def tasks
    tasks = object.tasks.with_status(instance_options[:task_status]).recent

    ActiveModelSerializers::SerializableResource.new(tasks, each_serializer: TaskSerializer).as_json
  end
end
