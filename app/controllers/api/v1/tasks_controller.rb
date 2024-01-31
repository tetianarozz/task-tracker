module Api
  module V1
    class TasksController < BaseController
      before_action :set_task, only: %i[show update destroy]

      def index
        tasks = Task.all

        render_resources(resources: tasks)
      end

      def show
        render_resource(resource: @task)
      end

      def create
        task = Task.new(task_params)
        task.save

        render_resource_or_errors(resource: task, success_status: :created)
      end

      def update
        @task.update(task_params)

        render_resource_or_errors(resource: @task)
      end

      def destroy
        @task.destroy

        render_ok_response(message: 'Task was successfully deleted!', status: :no_content)
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:name, :description, :status, :project_id)
      end
    end
  end
end