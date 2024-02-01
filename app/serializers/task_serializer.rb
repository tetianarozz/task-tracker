class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :project_id
end
