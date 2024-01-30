module Api
  module V1
    class ProjectsController < BaseController
      before_action :set_project, only: %i[show update destroy]

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

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
