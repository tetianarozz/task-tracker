class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  attribute :tasks, if: -> { instance_options[:with_tasks].present? }

  def tasks
    object.tasks.with_status(instance_options[:task_status]).recent
  end
end
