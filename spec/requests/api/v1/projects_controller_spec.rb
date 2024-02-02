require 'rails_helper'

RSpec.describe Api::V1::ProjectsController do
  include_context 'with api authorization'

  let(:project) { create(:project) }

  describe 'GET /projects' do
    subject(:request) { get '/api/v1/projects', headers: headers }

    before do
      create_list(:project, 2)
      request
    end

    context 'when request successful' do
      it_behaves_like 'responds with correct status', :ok

      it 'returns all projects' do
        expect(response.parsed_body.count).to eq Project.count
      end
    end
  end

  describe 'GET /projects/{id}' do
    subject(:request) { get "/api/v1/projects/#{project_id}", headers: headers }

    before { request }

    context 'when request successful' do
      let(:project_id) { project.id }

      it_behaves_like 'responds with correct status', :ok

      it 'returns correct project name' do
        expect(response.parsed_body['name']).to eq(project.name)
      end

      it 'returns correct project description' do
        expect(response.parsed_body['description']).to eq(project.description)
      end
    end

    context 'when request failed' do
      let(:project_id) { 0 }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Project not found!'
      end
    end
  end

  describe 'POST /projects' do
    subject(:request) { post '/api/v1/projects', params: params, headers: headers }

    let(:valid_project_attributes) { attributes_for(:project) }
    let(:invalid_project_attributes) { attributes_for(:project, name: nil) }

    before { request }

    context 'with valid parameters' do
      let(:params) { { project: valid_project_attributes } }

      it_behaves_like 'responds with correct status', :created

      it 'creates a correct project name' do
        expect(response.parsed_body['name']).to eq(valid_project_attributes[:name])
      end

      it 'creates a correct project description' do
        expect(response.parsed_body['description']).to eq(valid_project_attributes[:description])
      end
    end

    context 'with invalid parameters' do
      let(:params) { { project: invalid_project_attributes } }

      it_behaves_like 'responds with correct status', :unprocessable_entity

      it 'does not create a new project' do
        expect { request }.not_to change(Project, :count)
      end
    end
  end

  describe 'PUT /projects' do
    subject(:request) { put "/api/v1/projects/#{project.id}", params: params, headers: headers }

    let(:valid_project_attributes) { attributes_for(:project) }
    let(:invalid_project_attributes) { attributes_for(:project, name: nil) }

    before { request }

    context 'with valid parameters' do
      let(:params) { { project: valid_project_attributes } }

      it_behaves_like 'responds with correct status', :ok

      it 'updates the project' do
        expect(project.reload.attributes.symbolize_keys).to include(valid_project_attributes)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { project: invalid_project_attributes } }

      it_behaves_like 'responds with correct status', :unprocessable_entity

      it 'does not update the project' do
        expect(project.reload.attributes.symbolize_keys).not_to include(invalid_project_attributes)
      end
    end
  end

  describe 'DELETE /projects/{id}' do
    subject(:request) { delete "/api/v1/projects/#{project_id}", headers: headers }

    before { request }

    context 'when request successful' do
      let(:project_id) { project.id }

      it_behaves_like 'responds with correct status', :no_content

      it 'deletes the project' do
        expect(Project.find_by(id: project_id)).to be_nil
      end
    end

    context 'when request fails' do
      let(:project_id) { 0 }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Project not found!'
      end
    end
  end

  describe 'GET /projects/{project_id}/tasks' do
    subject(:request) { get "/api/v1/projects/#{project_id}/tasks", params: params, headers: headers }

    before do
      create_list(:task, 2, project: project, status: :new)
      create_list(:task, 2, project: project, status: :in_progress)
      create_list(:task, 2, project: project, status: :completed)
      create_list(:task, 2, status: :new)
      request
    end

    let(:params) { status.present? ? { task_status: status } : {} }

    context 'with valid project_id and not passed status' do
      let(:project_id) { project.id }

      it_behaves_like 'responds with correct status', :ok

      it 'returns all project tasks' do
        expect(response.parsed_body['tasks'].count).to eq project.tasks.count
      end
    end

    context 'with invalid project id' do
      let(:project_id) { 0 }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns an error message' do
        expect(response.parsed_body['error']).to eq 'Project not found!'
      end
    end

    context 'when passed correct project_id and status new' do
      let(:project_id) { project.id }
      let(:status) { 'new' }

      it_behaves_like 'responds with correct status', :ok

      it 'returns only project tasks with status new' do
        expect(response.parsed_body['tasks'].count).to eq project.tasks.with_status(status).count
      end
    end

    context 'with valid project id and invalid status' do
      let(:project_id) { project.id }
      let(:status) { 'invalid' }

      it 'responds with bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        expect(response.parsed_body['error']).to eq 'Status is invalid!'
      end
    end
  end
end
