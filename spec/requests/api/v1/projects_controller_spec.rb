require 'rails_helper'

RSpec.describe Api::V1::ProjectsController do
  require 'support/shared_examples/response_statuses'

  let(:project) { create(:project) }
  let(:valid_project_attributes) { attributes_for(:project) }
  let(:invalid_project_attributes) { attributes_for(:project, name: nil) }
  let(:random_number) { Faker::Number.number(digits: 2) }

  describe 'GET /projects' do
    subject(:request) { get '/api/v1/projects' }

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
    subject(:request) { get "/api/v1/projects/#{project_id}" }

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
      let(:project_id) { random_number }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Project not found!'
      end
    end
  end

  describe 'POST /projects' do
    subject(:request) { post '/api/v1/projects', params: params }

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
    subject(:request) { put "/api/v1/projects/#{project.id}", params: params }

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
    subject(:request) { delete "/api/v1/projects/#{project_id}" }

    before { request }

    context 'when request successful' do
      let(:project_id) { project.id }

      it_behaves_like 'responds with correct status', :no_content

      it 'deletes the project' do
        expect(Project.find_by(id: project_id)).to be_nil
      end
    end

    context 'when request fails' do
      let(:project_id) { random_number }

      it_behaves_like 'responds with correct status', :not_found

      it 'returns error message' do
        expect(response.parsed_body['error']).to eq 'Project not found!'
      end
    end
  end
end
