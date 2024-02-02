require 'rails_helper'

RSpec.describe Api::V1::TasksController do
  include_context 'with api authorization'

  let(:task) { create(:task) }

  describe 'GET /tasks/{id}' do
    subject(:request) { get "/api/v1/tasks/#{task_id}", headers: headers }

    before { request }

    context 'when request successful' do
      let(:task_id) { task.id }

      it_behaves_like 'responds with correct status', :ok

      it 'returns correct task name' do
        expect(response.parsed_body['name']).to eq(task.name)
      end

      it 'returns correct task description' do
        expect(response.parsed_body['description']).to eq(task.description)
      end

      it 'returns correct task status' do
        expect(response.parsed_body['status']).to eq(task.status)
      end
    end

    context 'when request failed' do
      let(:task_id) { 0 }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Task not found!'
      end
    end
  end

  describe 'POST /tasks' do
    subject(:request) { post '/api/v1/tasks', params: params, headers: headers }

    let(:valid_task_attributes) { attributes_for(:task, project_id: task.project_id) }
    let(:invalid_task_attributes) { attributes_for(:task, name: nil) }

    before { request }

    context 'with valid parameters' do
      let(:params) { { task: valid_task_attributes } }

      it_behaves_like 'responds with correct status', :created

      it 'creates a correct task project' do
        expect(Task.last.project).to eq(task.project)
      end

      it 'creates a correct task name' do
        expect(response.parsed_body['name']).to eq(valid_task_attributes[:name])
      end

      it 'creates a correct task description' do
        expect(response.parsed_body['description']).to eq(valid_task_attributes[:description])
      end

      it 'creates a correct task status' do
        expect(response.parsed_body['status']).to eq(valid_task_attributes[:status])
      end
    end

    context 'with invalid parameters' do
      let(:params) { { task: invalid_task_attributes } }

      it_behaves_like 'responds with correct status', :unprocessable_entity

      it 'does not create a new task' do
        expect { request }.not_to change(Task, :count)
      end
    end
  end

  describe 'PUT /tasks' do
    subject(:request) { put "/api/v1/tasks/#{task.id}", params: params, headers: headers }

    let(:valid_task_attributes) { attributes_for(:task, project_id: task.project_id) }
    let(:invalid_task_attributes) { attributes_for(:task, name: nil) }

    before { request }

    context 'with valid parameters' do
      let(:params) { { task: valid_task_attributes } }

      it_behaves_like 'responds with correct status', :ok

      it 'updates the task' do
        expect(task.reload.attributes.symbolize_keys).to include(valid_task_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { task: invalid_task_attributes } }

      it_behaves_like 'responds with correct status', :unprocessable_entity

      it 'does not update the task' do
        expect(task.reload.name).not_to be_nil
      end
    end
  end

  describe 'DELETE /tasks/{id}' do
    subject(:request) { delete "/api/v1/tasks/#{task_id}", headers: headers }

    before { request }

    context 'when request successful' do
      let(:task_id) { task.id }

      it_behaves_like 'responds with correct status', :no_content

      it 'deletes the task' do
        expect(Task.find_by(id: task_id)).to be_nil
      end
    end

    context 'when request fails' do
      let(:task_id) { 0 }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Task not found!'
      end
    end
  end
end
