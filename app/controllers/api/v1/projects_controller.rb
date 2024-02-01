module Api
  module V1
    class ProjectsController < BaseController
      before_action :set_project, only: %i[show update destroy related_tasks]

      def index
        projects = Project.all

        render_resources(resources: projects)
      end

      def show
        render_resource(resource: @project)
      end

      def create
        project = Project.new(project_params)
        project.save

        render_resource_or_errors(resource: project, success_status: :created)
      end

      def update
        @project.update(project_params)

        render_resource_or_errors(resource: @project)
      end

      def destroy
        @project.destroy

        render_ok_response(message: 'Project was successfully deleted!', status: :no_content)
      end

      def related_tasks
        task_status = filtered_params[:task_status]

        return render_bad_request(msg: 'Status is invalid!') if task_status.present? && !Task.valid_status?(task_status)

        serialized_project = ProjectSerializer.new(@project, task_status: task_status, with_tasks: true).to_json

        render_resource(resource: serialized_project, serializer: nil)
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end

      def filtered_params
        params.permit(:task_status)
      end
    end
  end
end
